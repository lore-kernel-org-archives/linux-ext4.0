From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Thu, 05 Sep 2013 09:49:09 +0000
Message-ID: <52285395.1070508@hp.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, T Makphaibulchoke <tmac@hp.com>,
	adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, aswin@hp.com,
	torvalds@linux-foundation.org, aswin_proj@groups.hp.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130905023522.GA21268@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 09/05/2013 02:35 AM, Theodore Ts'o wrote:
> How did you gather these results?  The mbcache is only used if you are
> using extended attributes, and only if the extended attributes don't
> fit in the inode's extra space.
> 
> I checked aim7, and it doesn't do any extended attribute operations.
> So why are you seeing differences?  Are you doing something like
> deliberately using 128 byte inodes (which is not the default inode
> size), and then enabling SELinux, or some such?
> 
> 						- Ted
> 

No, I did not do anything special, including changing an inode's size. I just used the profile data, which indicated mb_cache module as one of the bottleneck.  Please see below for perf data from one of th new_fserver run, which also shows some mb_cache activities.


                        |--3.51%-- __mb_cache_entry_find
                        |          mb_cache_entry_find_first
                        |          ext4_xattr_cache_find
                        |          ext4_xattr_block_set
                        |          ext4_xattr_set_handle
                        |          ext4_initxattrs
                        |          security_inode_init_security
                        |          ext4_init_security
                        |          __ext4_new_inode
                        |          ext4_create
                        |          vfs_create
                        |          lookup_open
                        |          do_last
                        |          path_openat
                        |          do_filp_open
                        |          do_sys_open
                        |          SyS_open
                        |          sys_creat
                        |          system_call
                        |          __creat_nocancel
                        |          |
                        |          |--16.67%-- 0x11fe2c0
                        |          |

Thanks,
Mak.
