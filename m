From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fixup 64-bit divides in linux-3.0 stable backport
 of upstream fix
Date: Fri, 5 Apr 2013 19:32:29 -0400
Message-ID: <20130405233228.GA6597@thunk.org>
References: <1365202463-25872-1-git-send-email-toddpoynor@google.com>
 <20130405230107.GA8412@kroah.com>
 <CAAW3YpbM7Vk_=qXv2NCgRsCkashsTpYC_6osA_udm2oDsiz5qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Lingzhu Xiang <lxiang@redhat.com>, linux-ext4@vger.kernel.org
To: Todd Poynor <toddpoynor@google.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAW3YpbM7Vk_=qXv2NCgRsCkashsTpYC_6osA_udm2oDsiz5qA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 05, 2013 at 04:18:15PM -0700, Todd Poynor wrote:
> Perhaps the better fix is to revert those additional changes and let
> the ext4 folks figure out what to do about the remaining atomic_reads.
> 
> > And care to cc: the ext4 developers/maintainers when sending ext4
> > patches?

Can you send me the original patch?  I'd like to fix the problem
upstream first....  I'm curious why I didn't notice this, since I run
tests (and thus build) 32-bit x86 kernels, and Eric Whitney is doing
test builds and runs regression tests an ARM Pandaboard.  Can you give
me details about your compilation environment and how this causing
problems for you?

Thanks,

						- Ted
