From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/5] ext4: RFC: Encryption
Date: Thu, 24 Jul 2014 00:34:59 +0200
Message-ID: <20140723223459.GA29197@amd.pavel.ucw.cz>
References: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
 <20140723222506.GA29033@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, herbert@gondor.apana.org.au,
	hch@infradead.org, lczerner@redhat.com, tytso@mit.edu,
	tyhicks@canonical.com, serge.hallyn@canonical.com
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140723222506.GA29033@amd.pavel.ucw.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 2014-07-24 00:25:06, Pavel Machek wrote:
> Hi!
> > This patchset proposes a method for encrypting in EXT4 data read and
> > write paths. It's a proof-of-concept/prototype only right
> > now. Outstanding issues:
> > 
> >  * While it seems to work well with complex tasks like a parallel
> >    kernel build, fsx is pretty good at reliably breaking it in its
> >    current form. I think it's trying to decrypt a page of all zeros
> >    when doing a mmap'd write after an falloc. I want to get feedback
> >    on the overall approach before I spend too much time bug-hunting.

> Can I keep just a subtree (/home/pavel/.ssh) encrypted?

Ok, as far as I can tell no, this is whole filesystem encryption for
now. I guess encrypting based on some attribute is planned...?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
