package com.nati.petadoptapp.presentation

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.core.view.forEach
import androidx.navigation.findNavController
import androidx.navigation.fragment.NavHostFragment
import com.nati.petadoptapp.R
import com.nati.petadoptapp.databinding.ActivityMainBinding


class MainActivity : AppCompatActivity() {

    private val binding: ActivityMainBinding by lazy {
        ActivityMainBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)


        val navHostFragment =
            supportFragmentManager.findFragmentById(R.id.fcv_main) as NavHostFragment
        val navController = navHostFragment.navController
        navController.addOnDestinationChangedListener { _, destination, _ ->
            when (destination.id) {
                R.id.signInFragment -> {
                    binding.bottomNavigation.visibility = View.GONE
                    binding.bottomNavigation.menu.forEach { menuItem ->
                        if (menuItem.itemId == R.id.item_profile) {
                            if (menuItem.isChecked) {
                                menuItem.isChecked = false
                            }
                        } else if (menuItem.itemId == R.id.item_home) {
                            menuItem.isChecked = true
                        }
                    }
                }

                R.id.signUpFragment -> {
                    binding.bottomNavigation.visibility = View.GONE
                }

                R.id.petListFragment -> {
                    binding.bottomNavigation.visibility = View.VISIBLE
                }

                R.id.organizationListFragment -> {
                    binding.bottomNavigation.visibility = View.VISIBLE
                }

                R.id.petDetailFragment -> {
                    binding.bottomNavigation.visibility = View.GONE
                }

                R.id.organizationDetailFragment -> {
                    binding.bottomNavigation.visibility = View.GONE
                }

                R.id.profileFragment -> {
                    binding.bottomNavigation.visibility = View.VISIBLE
                }
            }
        }

        binding.bottomNavigation.setOnItemSelectedListener { item ->
            when (item.itemId) {
                R.id.item_home -> {
                    findNavController(R.id.fcv_main).navigate(R.id.petListFragment)
                    true
                }

                R.id.item_org -> {
                    findNavController(R.id.fcv_main).navigate(R.id.organizationListFragment)
                    true
                }

                R.id.item_profile -> {
                    findNavController(R.id.fcv_main).navigate(R.id.profileFragment)
                    true
                }

                else -> false
            }
        }
    }


}
