From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 08/19] ext4: replace inode uid,gid,mode initialization with
 helper function
Date: Wed, 17 Feb 2010 16:39:54 -0700
Message-ID: <E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
 <1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2010-02-17, at 11:40, Dmitry Monakhov wrote:
> @@ -985,16 +985,12 @@ got:
> 		atomic_dec(&sbi->s_flex_groups[flex_group].free_inodes);
> 	}
>
> +	if (test_opt (sb, GRPID)) {

(style) please don't add the space after "test_opt" back into the code.


> +		inode->i_mode = mode;
> +		inode->i_uid = current_fsuid();
> 		inode->i_gid = dir->i_gid;
> 	} else
> +		inode_init_owner(inode, dir, mode);


This code is a bit misleading, since it implies that "i_uid" and  
"i_mode" are set this way due to the GRPID option, even though with  
further investigation it is just set the same way in both cases.

Ted,
what do you think of just removing the "GRPID" mount option?  I  
believe this was around for ages, due to the lack of BSD setgid-on- 
parent functionality in Linux.  I don't think it is needed anymore,  
since the BSD functionality is much more flexible (it can be set on a  
per-directory basis instead of for the whole filesystem).

I suppose one way to find out positively would be to add a printk() to  
case Opt_grpid: in the option parsing that this option is deprecated,  
and to contact linux-ext4@vger.kernel.org if you are still using it.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

