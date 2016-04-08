From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 1/4] percpu_stats: Simple per-cpu statistics count
 helper functions
Date: Sat, 9 Apr 2016 01:45:31 +0800
Message-ID: <201604090123.yO6ZZ440%fengguang.wu@intel.com>
References: <1460132182-11690-2-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Cc: kbuild-all@01.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460132182-11690-2-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Waiman,

[auto build test ERROR on ext4/dev]
[also build test ERROR on v4.6-rc2 next-20160408]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Waiman-Long/ext4-Improve-parallel-I-O-performance-on-NVDIMM/20160409-002128
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
config: um-x86_64_defconfig (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um SUBARCH=x86_64

Note: the linux-review/Waiman-Long/ext4-Improve-parallel-I-O-performance-on-NVDIMM/20160409-002128 HEAD 712a939b92b9178cb79df4050bba8e6b1d03ca63 builds fine.
      It only hurts bisectibility.

All error/warnings (new ones prefixed by >>):

   In file included from arch/um/include/generated/asm/percpu.h:1:0,
                    from include/linux/percpu.h:12,
                    from include/linux/percpu_stats.h:7,
                    from lib/percpu_stats.c:5:
   include/linux/percpu_stats.h: In function 'percpu_stats_add':
>> include/asm-generic/percpu.h:120:2: error: implicit declaration of function 'raw_local_irq_save' [-Werror=implicit-function-declaration]
     raw_local_irq_save(__flags);     \
     ^
>> include/asm-generic/percpu.h:322:34: note: in expansion of macro 'this_cpu_generic_to_op'
    #define this_cpu_add_1(pcp, val) this_cpu_generic_to_op(pcp, val, +=)
                                     ^
>> include/linux/percpu-defs.h:364:11: note: in expansion of macro 'this_cpu_add_1'
      case 1: stem##1(variable, __VA_ARGS__);break;  \
              ^
   include/linux/percpu-defs.h:496:33: note: in expansion of macro '__pcpu_size_call'
    #define this_cpu_add(pcp, val)  __pcpu_size_call(this_cpu_add_, pcp, val)
                                    ^
>> include/linux/percpu_stats.h:29:2: note: in expansion of macro 'this_cpu_add'
     this_cpu_add(pcs->stats[stat], cnt);
     ^
>> include/asm-generic/percpu.h:122:2: error: implicit declaration of function 'raw_local_irq_restore' [-Werror=implicit-function-declaration]
     raw_local_irq_restore(__flags);     \
     ^
>> include/asm-generic/percpu.h:322:34: note: in expansion of macro 'this_cpu_generic_to_op'
    #define this_cpu_add_1(pcp, val) this_cpu_generic_to_op(pcp, val, +=)
                                     ^
>> include/linux/percpu-defs.h:364:11: note: in expansion of macro 'this_cpu_add_1'
      case 1: stem##1(variable, __VA_ARGS__);break;  \
              ^
   include/linux/percpu-defs.h:496:33: note: in expansion of macro '__pcpu_size_call'
    #define this_cpu_add(pcp, val)  __pcpu_size_call(this_cpu_add_, pcp, val)
                                    ^
>> include/linux/percpu_stats.h:29:2: note: in expansion of macro 'this_cpu_add'
     this_cpu_add(pcs->stats[stat], cnt);
     ^
   cc1: some warnings being treated as errors

vim +/raw_local_irq_save +120 include/asm-generic/percpu.h

eba117889a Tejun Heo 2014-06-17  114  	__ret;								\
9c28278a24 Tejun Heo 2014-06-17  115  })
9c28278a24 Tejun Heo 2014-06-17  116  
eba117889a Tejun Heo 2014-06-17  117  #define this_cpu_generic_to_op(pcp, val, op)				\
9c28278a24 Tejun Heo 2014-06-17  118  do {									\
eba117889a Tejun Heo 2014-06-17  119  	unsigned long __flags;						\
eba117889a Tejun Heo 2014-06-17 @120  	raw_local_irq_save(__flags);					\
9c28278a24 Tejun Heo 2014-06-17  121  	*raw_cpu_ptr(&(pcp)) op val;					\
eba117889a Tejun Heo 2014-06-17 @122  	raw_local_irq_restore(__flags);					\
9c28278a24 Tejun Heo 2014-06-17  123  } while (0)
9c28278a24 Tejun Heo 2014-06-17  124  
eba117889a Tejun Heo 2014-06-17  125  #define this_cpu_generic_add_return(pcp, val)				\

:::::: The code at line 120 was first introduced by commit
:::::: eba117889ac444bea6e8270049cbaeed48169889 percpu: preffity percpu header files

:::::: TO: Tejun Heo <tj@kernel.org>
:::::: CC: Tejun Heo <tj@kernel.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--HlL+5n6rz5pIUxbD
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--HlL+5n6rz5pIUxbD--
