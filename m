From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Fri, 24 Nov 2017 22:54:23 -0500
Message-ID: <20171125035423.4rskbrgluqtxztag@thunk.org>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171124165102.GS2482@two.firstfloor.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 24, 2017 at 08:51:02AM -0800, Andi Kleen wrote:
> > I think e2fsck can fix this quite easily, and there really isn't
> > an easy way to revert to the old method if the large xattr feature
> > is enabled.  If you are willing to run a new kernel, you should also
> > be willing to run a new e2fsck.
> 
> It's obviously not enabled on ext3.

Yes, I think it's clear we need to enable a backwards compatibility
support for ext3 file systems, or even all ext4 file systems that
don't have the large xattr feature.

We could have e2fsck offer to fix it, so long as it is being run
manually (e.g., not in preen mode), since it does have the benefit of
releasing unnecessarily allocated 4k blocks for symlinks which are <
60 bytes.

						- Ted
