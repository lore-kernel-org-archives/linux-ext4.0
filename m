From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 06/12 v2] mm: teach truncate_inode_pages_range() to hadnle
 non page aligned ranges
Date: Thu, 19 Jul 2012 09:15:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207190905220.4970@localhost>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com> <1342185555-21146-6-git-send-email-lczerner@redhat.com> <alpine.LSU.2.00.1207170114490.1577@eggly.anvils> <alpine.LFD.2.00.1207171315330.2402@dhcp-1-248.brq.redhat.com>
 <alpine.LFD.2.00.1207171413350.14869@dhcp-1-248.brq.redhat.com> <alpine.LFD.2.00.1207180945390.2291@dhcp-1-248.brq.redhat.com> <alpine.LSU.2.00.1207181154410.2160@eggly.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.1207181154410.2160@eggly.anvils>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 18 Jul 2012, Hugh Dickins wrote:

> Date: Wed, 18 Jul 2012 12:36:39 -0700 (PDT)
> From: Hugh Dickins <hughd@google.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>,
>     Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>,
>     Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
> Subject: Re: [PATCH 06/12 v2] mm: teach truncate_inode_pages_range() to hadnle
>      non page aligned ranges
> 
> On Wed, 18 Jul 2012, Lukas Czerner wrote:
> > On Tue, 17 Jul 2012, Lukas Czerner wrote:
> > > 
> > > My bad, it definitely is not safe without the end offset argument in
> > > invalidatepage() aops ..sigh..
> > 
> > So what about having new aop invalidatepage_range and using that in
> > the truncate_inode_pages_range(). We can still BUG_ON if the file
> > system register invalidatepage, but not invalidatepage_range,
> > when the range to truncate is not page aligned at the end.
> 
> I had some trouble parsing what you wrote, and have slightly adjusted
> it (mainly adding a comma) to fit my understanding: shout at me if I'm
> misrepresenting you!
> 
> Yes, I think that's what has to be done.  It's irritating to have two
> methods doing the same job, but not nearly so irritating as having to
> change core and all filesystems at the same time.  Then at some future
> date there can be a cleanup to remove the old invalidatepage method.

Agreed!

> 
> > 
> > I am sure more file system than just ext4 can take advantage of
> > this. Currently only ext4, xfs and ocfs2 support punch hole and I
> > think that all of them can use truncate_inode_pages_range() which
> > handles unaligned ranges.
> 
> I expect that they can, but I'm far from sure of it: each filesystem
> will have its own needs and difficulties, which might delay them from
> a quick switchover to invalidatepage_range.
> 
> > 
> > Currently ext4 has it's own overcomplicated method of freeing and
> > zeroing unaligned ranges.
> 
> You're best placed to judge if its overcomplicated, I've not looked.
> 
> > Xfs seems just truncate the whole file and
> 
> I doubt that can be the case: how would it ever pass testing with
> the hole-punching fsx if so?  But it is the case that xfs unmaps
> all the pages from hole onwards, in the exceptional case where the
> punched file is currently mmap'ed into userspace; and that is wrong,
> and will get fixed, but it's not a huge big deal meanwhile.  (But it
> does suggest that hole-punching is more difficult to get completely
> right than people think at first.)

Ok, maybe I did not express myself very well, sorry. I meant to say
that xfs will unmap all mapped pages in the file from start of the
hole to the end of the file.

> 
> > there seems to be a bug in ocfs2 where we can hit BUG_ON when the
> > cluster size < page size.
> > 
> > What do you reckon ?
> 
> I agree that you need invalidatepage_range for truncate_inode_page_range
> to drop its end alignment restriction.  But now that we have to add a
> method, I think it would be more convincing justification to have two
> filesystems converted to make use of it, than just the one ext4.

Ok, I'll do this and try to see what I can do with some other file
systems as well.

Thanks!
-Lukas

> 
> Hugh
> 
