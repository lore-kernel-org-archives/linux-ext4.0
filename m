From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC 1/4] fs: Add generic file system event notifications
Date: Fri, 17 Apr 2015 10:48:29 +0200
Message-ID: <20150417084829.GC3116@quack.suse.cz>
References: <1429082147-4151-1-git-send-email-b.michalska@samsung.com>
 <1429082147-4151-2-git-send-email-b.michalska@samsung.com>
 <20150415192529.GC11592@birch.djwong.org>
 <552F7155.3050504@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-kernel@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, hughd@google.com, lczerner@redhat.com,
	hch@infradead.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	kyungmin.park@samsung.com, kmpark@infradead.org
To: Beata Michalska <b.michalska@samsung.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <552F7155.3050504@samsung.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu 16-04-15 10:22:45, Beata Michalska wrote:
> On 04/15/2015 09:25 PM, Darrick J. Wong wrote:
> > On Wed, Apr 15, 2015 at 09:15:44AM +0200, Beata Michalska wrote:
> > 
> >> +#define FS_THRESH_LR_REACHED	0x00000020	/* The lower range of threshold has been reached */
> >> +#define FS_THRESH_UR_REACHED	0x00000040	/* The upper range of threshold has been reached */
> >> +#define FS_ERR_UNKNOWN		0x00000080	/* Unknown error */
> >> +#define FS_ERR_RO_REMOUT	0x00000100	/* The file system has been remounted as red-only */
> > 
> > _REMOUNT... read-only...
> > 
> >> +#define FS_ERR_ITERNAL		0x00000200	/* File system's internal error */
> > 
> > _INTERNAL...
> > 
> > What does FS_ERR_ITERNAL mean?  "programming error"?
> > 
> FS_ERR_ITERNAL is supposed to mean smth than can not be easily translated
> into generic event code - so smth that is specific for given file system type.
> 
> 
> > How about a separate FS_ERR_CORRUPTED to mean "go run fsck"?
> 
> Sounds like a good idea.
> 
> > 
> > Hmm, these are bit flags... it doesn't make sense that I can send things like
> > FS_INFO_UMOUNT | FS_ERR_RO_REMOUT.
> > 
> 
> You can but you shouldn't. Possibly some sanity checks could be added
> for such cases. I was thinking of possibly merging events for the same
> file system and sending them in one go - so a single message could contain
> multiple events. Though this requires some more thoughts.
  Well, I don't think merging events makes some sense. I don't expect that
many messages going over this interface so that merging would be necessary
to get a good performance. And when you merge events, you loose information
about the order - like was it below_limit_info and then above_limit_warn or
the other way around? Also evens might carry other data with them in which
case merging is impossible anyway.

So I'd vote for just not allowing merging and making message type a simple
enum.

								Honza

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
