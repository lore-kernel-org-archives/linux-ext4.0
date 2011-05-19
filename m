From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Thu, 19 May 2011 12:57:08 +0200
Message-ID: <20110519105708.GD8417@quack.suse.cz>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <20110518180022.GM18929@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	tytso@mit.edu, Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110518180022.GM18929@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 18-05-11 11:00:22, Darrick J. Wong wrote:
> On Wed, May 18, 2011 at 05:17:59PM +0200, Jan Kara wrote:
> > 
> >   Hi,
> > 
> >   this is a second version of my patches which rewrite ext4_page_mkwrite() to
> > use generic helper. When we are already changing this code, I also added proper
> > handling of frozen filesystem there in patch 2/3. I've incorporated suggestions
> > from Christoph in the patches which resulted in some patch reorg. I'd like to
> > get these patches reviewed and then get them merged possibly via ext4-tree
> > (although the first two patches might go via Al but that would complicate
> > merging of ext4 part where I expect more conflicts with ongoing work).
> 
> Do you want me to generate a patch to add wait_on_page_writeback to the
> appropriate place(s) in your new *_page_mkwrite functions, or do you plan to
> add them yourself?
  Since Ted has merged your stable pages patches touching ext4, I'll rebase
my ext4 patch on top of that. Regarding block_page_mkwrite() I will add
that one-liner to the series (because the ext4_page_mkwrite() now depends
on that).

									Honza
