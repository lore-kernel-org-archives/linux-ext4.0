From: "Kani, Toshi" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH 1/2] ext4, dax: update dax check to skip journal inode
Date: Wed, 12 Sep 2018 15:47:12 +0000
Message-ID: <92faf51ac89e62dcd67e39cc66eef60966d1263c.camel@hpe.com>
References: <20180911154246.6844-1-toshi.kani@hpe.com>
 <20180911154246.6844-2-toshi.kani@hpe.com>
 <20180912092422.GA7782@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "tytso-3s7WtUTddSA@public.gmane.org" <tytso-3s7WtUTddSA@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org" <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180912092422.GA7782-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Content-ID: <EF936500EEE4E946A008D2BE76FDBC73-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Wed, 2018-09-12 at 11:24 +0200, Jan Kara wrote:
> On Tue 11-09-18 09:42:45, Toshi Kani wrote:
> > Ext4 mount path calls ext4_iget() to obtain the journal inode.  This
> > inode does not support DAX, and 'ext4_da_aops' needs to be set.  It
> > currently works for the DAX mount case because ext4_iget() always set
> > 'ext4_da_aops' to any regular files.
> > 
> >   ext4_fill_super
> >     ext4_load_journal
> >       ext4_get_journal_inode
> >         ext4_iget
> > 
> > In preparation to fix ext4_iget() to set 'ext4_dax_aops' for DAX files,
> > update ext4_should_use_dax() to return false for the journal inode.
> > 
> > Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
> > Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> > Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> > Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> 
> The journal inode is similar to any other 'system' inode we have in ext4.
> We don't really expect any of the address space operations to be called for
> it because we don't use page cache with these inodes. Very similar
> situation is with e.g. quota files. So to me it seems this patch is not
> really necessary. Or did you observe any bad effects without this patch?

Yes, without this change, mount fails with the error below.  I believe
.bmap operation in ext4_da_aops is necessary for this case.

  jbd2_journal_init_inode: Cannot locate journal superblock
  EXT4-fs
(pmem1): Could not load journal inode

> That being said I agree that it would be a good cleanup to define something
> like ext4_is_system_inode() and disable DAX for these inodes just because
> they are special. But I don't see a need for this as a part of your fix.

Is there other system inode we need to check for?

Thanks,
-Toshi
