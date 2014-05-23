From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] quota: remove dqptr_sem for scalability
Date: Thu, 22 May 2014 23:02:28 -0500
Message-ID: <537EC854.1060605@redhat.com>
References: <537DD5BA.1050105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: yawei.niu@intel.com, andreas.dilger@intel.com, jack@suse.cz,
	lai.siyao@intel.com
To: Niu Yawei <yawei.niu@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <537DD5BA.1050105@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/22/14, 5:47 AM, Niu Yawei wrote:
> There are several global locks in the VFS quota code which hurts
> performance a lot when quota accounting enabled, dqptr_sem is the major one.
> 
> This patch tries to make the VFS quota code scalable with minimal changes.
> 
> Following tests (mdtest & dbench) were running over ext4 fs in a
> centos6.5 vm (8 cpus, 4G mem, kenrel: 3.15.0-rc5+), and the result shows
> the patch relieved the lock congestion a lot.
> 

Just noticed this patch - FWIW, Lustre has a 
"quota-replace-dqptr-sem-sles11sp2.patch" that they apply:

http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob;f=lustre/kernel_patches/patches/quota-replace-dqptr-sem-sles11sp2.patch;h=c880dac83473f48cac96dc467ea76f64a74fe5dd;hb=HEAD

which might be interesting if you're looking at this.

(Or maybe it's doing the same thing; TBH I have not looked at
either patch, I just remembered that it existed...)

-eric
