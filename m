From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/2] ext4: MMP: kmmpd should use nodename from init_uts_ns.name, not sysname
Date: Fri, 23 Sep 2011 12:51:05 -0600
Message-ID: <83CFA343-D1F7-4FD7-B2F1-DAC638FF7C91@dilger.ca>
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com> <1316737389-5522-2-git-send-email-nikitas_angelinas@xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Johann Lombardi <johann@whamcloud.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-kernel Kernel <linux-kernel@vger.kernel.org>,
	Nikitas Angelinas <nikitas_angelinas@xyratex.com>,
	andrew_perepechko@xyratex.com
To: Nikitas Angelinas <nikitasangelinas@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1316737389-5522-2-git-send-email-nikitas_angelinas@xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-09-22, at 6:23 PM, Nikitas Angelinas wrote:
> sysname holds "Linux" by default, i.e. what appears when doing a "uname
> -s"; nodename should be used to print the machine's hostname, i.e. what
> is returned when doing a "uname -n" or "hostname", and what
> gethostname(2)/sethostname(2) manipulate, in order to notify the
> administrator of the node which is contending to mount the filesystem.
> 
> Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
> Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>

This looks to have crept in with the port of the patch to RHEL6, which
required the code to stop accessing system_utsname directly and instead
using the init_utsname() helper to access the structure.  That version
of the patch was contributed by an external developer, so I can't really
say why it was done, probably just an oversight.  In our RHEL5 patch it
used to be:

       memcpy(mmp->mmp_nodename, system_utsname.nodename,
              sizeof(mmp->mmp_nodename));

You can add Acked-by: Andreas Dilger <adilger@dilger.ca>.

Thanks for the fix.

> ---
> fs/ext4/mmp.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 9bdef3f..2fca64e 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -109,7 +109,7 @@ static int kmmpd(void *data)
> 	mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
> 	bdevname(bh->b_bdev, mmp->mmp_bdevname);
> 
> -	memcpy(mmp->mmp_nodename, init_utsname()->sysname,
> +	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
> 	       sizeof(mmp->mmp_nodename));
> 
> 	while (!kthread_should_stop()) {
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
