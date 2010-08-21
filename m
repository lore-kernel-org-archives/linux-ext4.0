From: Richard Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [PATCH] ext4: remove alignment padding from ext4_inode_info on
 64 bit builds
Date: Sat, 21 Aug 2010 13:31:38 +0100
Message-ID: <1282393898.1978.18.camel@castor.rsk>
References: <1282144088.2068.16.camel@castor.rsk>
	 <4C6EE173.3030204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C6EE173.3030204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2010-08-20 at 15:11 -0500, Eric Sandeen wrote:
> Richard Kennedy wrote:
> > Reorder structure ext4_inode_info to remove 16 bytes of alignment
> > padding on 64 bit builds. This shrinks its size from 904 to 888 bytes
> > with (CONFIG_EXT4_S_XATTR=y && CONFIG_QUOTA=n).
> >     
> > This will allow this structure to use one fewer cache lines.
> > 
> > Also change type of i_delalloc_reserved_flag to bool to better reflect
> > its usage.
> > 
> > compiled & tested on x86_64
> 
> 
> Looks good to me; there is still a bit of padding at the end:
> 
>         qsize_t                    i_reserved_quota;     /*   864     8 */
>         struct list_head           i_completed_io_list;  /*   872    16 */
>         spinlock_t                 i_completed_io_lock;  /*   888     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         /* --- cacheline 14 boundary (896 bytes) --- */
>         ext4_io_end_t *            cur_aio_dio;          /*   896     8 */
>         tid_t                      i_sync_tid;           /*   904     4 */
>         tid_t                      i_datasync_tid;       /*   908     4 */
> 
> 
> but it wouldn't save a cacheline anyway...
> 
> -Eric
> 
Thanks Eric, yes there is padding but we don't have anything to fill the
hole with :(

If it becomes important to save space, i_state_flags seem to be unused
in ext4 so we could possibly drop that.

With my patch applied, under slub I'm getting one more object per slab
in the ext4_inode_cache

[2.6.35] 17 objects of 960 bytes -- 4 pages per slab
[+patch] 18 objects of 896 bytes -- 4 pages per slab

So I guess that is where most of the write test performance improvement
came from.

regards
Richard
