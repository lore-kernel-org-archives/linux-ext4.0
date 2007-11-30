From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [RFC] support multiple max offset limits for a single
	superblock
Date: Fri, 30 Nov 2007 09:14:14 -0800
Message-ID: <20071130171414.GA5048@puku.stupidest.org>
References: <47503BB5.2010501@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47503BB5.2010501@sandeen.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 30, 2007 at 10:35:01AM -0600, Eric Sandeen wrote:

> I could do the same for ext4, but Chris Mason prodded me to think of something
> more generic... this is what I came up with.

I think it (for now) should remain in the few file-systems that are
affected to avoid making a new ->i_op right now.  If it turns out this
is a more commonly need in the future we could do this, but it seems a
bit heavy handy just yet given at present.

Also, it might turn at that it makes sense to to on-the-fly conversion
in the filesystem (where applicable) at some later stage, so this
wouldn't be useful there.  I assume it's probably hard to convert a
large bitmap-based ext4 file to an extent-based one (how large can a
transaction be?) but that might not always be the case and it's
probably fine for smaller files.

> (BTW another option would be to convert old-format files when
> accessed, but that has its own set of tradeoffs...)

I think doing that where possible makes more sense.  As I said above
I'm not sure how easy that is to do for all files, but then again fsck
could take care of those if prodded.
