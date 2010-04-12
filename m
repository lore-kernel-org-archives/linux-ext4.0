From: "Chen, Tim C" <tim.c.chen@intel.com>
Subject: RE: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Mon, 12 Apr 2010 13:54:03 -0600
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FE4FCE0C4@rrsmsx501.amr.corp.intel.com>
References: <1270682478.3755.58.camel@localhost.localdomain>
 <87d3y8wrq5.fsf@basil.nowhere.org> <20100409233325.GF1849@thunk.org>
 <EA929A9653AAE14F841771FB1DE5A1365FE4FCD4BC@rrsmsx501.amr.corp.intel.com>
 <20100410115816.GH1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Andi Kleen <andi@firstfloor.org>,
	john stultz <johnstul@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab0DLTya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Apr 2010 15:54:30 -0400
In-Reply-To: <20100410115816.GH1849@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>tytso@mit.edu wrote
>
>On Fri, Apr 09, 2010 at 05:48:23PM -0600, Chen, Tim C wrote:
>>  
>> Your patch did remove the contention on the j_state_lock for dbench
>> in my testing with 64 threads.  The contention point now
>> moves dcache_lock, which is also another tricky bottleneck.
>> 
>> In our other testing with FFSB that creates/rename/remove a 
>lot of directories,
>> we found that journal->j_revoke_lock was also heavily contended.
>> 
>
>Do you have lock_stat reports handy?  I'd love to take a look at them.
>
>Thanks,
>

Here's the lock_stat for dbench and ffsb respectively.

-- Tim

lock_stat for dbench:

 					class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
                             dcache_lock:       6025583        6290348           0.11       19839.44  1798082999.37        6444352        6455257           0.09        1098.09    18850261.22
                &(&vfsmount_lock)->rlock:         73901          76686           0.11          60.15      113381.57        1453130        1729218           0.11          77.81     1256803.55
               &(&dentry->d_lock)->rlock:         70544          70816           0.10          81.63       57218.45        3260359        9367952           0.10          87.68     2882612.48
                     cpufreq_driver_lock:         13957          13957           0.15          16.34       11674.72         191861         191900           0.15          18.25      127363.61
              &sb->s_type->i_mutex_key#6:         11469          11471           9.81       23837.58    15425101.39          19705          19832           0.99       12681.28     9526135.06
                        rcu_node_level_1:          6074           6078           0.14         119.79       61347.68         195893         526772           0.09         107.31      250906.16
            &(&sbinfo->stat_lock)->rlock:          4119           4201           0.11          58.20        5152.25         170931         485773           0.10          74.01      171147.12
                        clockevents_lock:          1303           1323           0.15          48.76        5762.88          32798          53769           0.46          47.28      132041.92
                     tick_broadcast_lock:          1072           1077           0.16          44.15        3567.97          51339          71398           0.18          66.81      145312.14
                              inode_lock:           862            870           0.16          19.43         896.55         122469         189716           0.10          39.86      132519.21

lock_stat for ffsb:

					class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
     &(&journal->j_revoke_lock)->rlock#2:       2776732        2797303           0.09        1226.54    25572406.37        5534106        7180109           0.08         940.11     4072313.72
   &(&inode->i_data.private_lock)->rlock:        877686         881325           0.10        1012.54     6852161.82        3877066        5037811           0.08         953.17     2419421.96
                        clockevents_lock:        748984         760650           0.12        1863.26   101406877.20        1060958        1382494           0.42        1308.88    11071530.40
                             dcache_lock:        388413         409694           0.12         864.01     1468208.41        1434252        2471228           0.09        2655.71     2629938.50
              &(&q->__queue_lock)->rlock:        211707         214131           0.11         813.65     1255954.31         464310        2882306           0.08         984.38     3729431.78
      &(&journal->j_state_lock)->rlock#2:        206642         206832           0.13        2312.55     3561899.14        1049032        1490515           0.08        2447.20     2079827.95
   &(&transaction->t_handle_lock)->rlo#2:        179770         180327           0.11         745.09      438500.40        1724000        1997981           0.08         795.20     1097502.30
                   &sbi->s_orphan_lock#2:        123150         123161           3.87       41421.17   406113809.87         408087         532092           0.17       36588.86     5151196.68
                 &(&n->list_lock)->rlock:        116548         117330           0.11          88.35       65548.86        2219789        4243060           0.08          87.43     1324289.71
       &(&journal->j_list_lock)->rlock#2:         71612          72458           0.11         814.83      257968.30         833686        3148049           0.08        