From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
	super_operation
Date: Thu, 18 Nov 2010 06:06:30 -0700
Message-ID: <20101118130630.GJ6178@parisc-linux.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@infradead.org, sandeen@redhat.com,
	Josef Bacik <josef@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 18, 2010 at 08:36:48AM +0100, Lukas Czerner wrote:
> There was concern that FITRIM ioctl is not common enough to be included
> in core vfs ioctl, as Christoph Hellwig pointed out there's no real point
> in dispatching this out to a separate vector instead of just through
> ->ioctl.

Um, are you and Josef working independently of each other?  You don't
seem to be cc'ing each other on your patches, and you're basically doing
the same thing.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
