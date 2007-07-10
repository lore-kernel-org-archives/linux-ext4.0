From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 2][PATCH 3/5] cleanups: set_jbd2_64bit_feature for
	>16TB ext4 fs
Date: Tue, 10 Jul 2007 16:50:24 -0400
Message-ID: <1184100624.3759.35.camel@localhost.localdomain>
References: <1183275392.4010.122.camel@localhost.localdomain>
	 <20070710163022.333ece67.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070710163022.333ece67.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:36:32 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> > than 32bit block sizes during mount time.  This ensure proper record
> > lenth when writing to the journal.
> 
> This patch isn't in Ted's kernel.org directory and hasn't been in -mm. 
> Where did it come from?  Is something amiss with ext4 patch management?
> 
Jose Santo posted it to linux-ext4 mailing list.

I agree this bug fix should included in Ted's git tree or mm tree. There
are other ext4 cleanups in this series that should goes to mm tree also.

> > Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> > Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
> > ---
> >  fs/ext4/super.c |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > Index: linux-2.6.22-rc4/fs/ext4/super.c
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 16:15:54.000000000 -0700
> > +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 16:16:10.000000000 -0700
> > @@ -1804,6 +1804,13 @@
> 
> Please prepare patches using `diff -p'
> 

Will do.

> >  		goto failed_mount3;
> >  	}
> >  
> > +	if (ext4_blocks_count(es) > 0xffffffffULL &&
> > +	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
> > +				       JBD2_FEATURE_INCOMPAT_64BIT)) {
> > +		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
> > +		goto failed_mount4;
> > +	}
> 
> It is not appropriate for the text "ext4" to appear in a JBD2 message.

This is part of ext4 code. Ext4 will set the 64-bit JBD2 flag if the fs
is larger than 32 bit blocks.

> >  	/* We have now updated the journal if required, so we can
> >  	 * validate the data journaling mode. */
> >  	switch (test_opt(sb, DATA_FLAGS)) {
> 
> 

