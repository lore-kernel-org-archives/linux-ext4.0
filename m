From: Eric Biggers <ebiggers@google.com>
Subject: Re: [RFD] Common userspace tool for fscypto
Date: Fri, 2 Dec 2016 16:40:40 -0800
Message-ID: <20161203004040.GB3508@google.com>
References: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
 <CA+POJK10M3_GhP_Ge4qkQF4gSNMUXVr5kem9Ak4EDmVRvRUg7g@mail.gmail.com>
 <f9bc005b-4e25-d705-e091-5f930e4246b1@nod.at>
 <CAKpBdu1+k94WmwxeZ2Hyu5=ifNprPA0YedRm2xps-ooyVHTwhg@mail.gmail.com>
 <87d9b3aa-684d-856a-0dcd-f960923f2484@nod.at>
 <20161130000407.GB107713@google.com>
 <3d354949-0051-3f3a-f8ac-8dd99e9adc0f@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joe Richey <joerichey@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, kzak@redhat.com,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        David Gstir <david@sigma-star.at>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3d354949-0051-3f3a-f8ac-8dd99e9adc0f@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 30, 2016 at 09:27:28AM +0100, Richard Weinberger wrote:
> 
> BTW: This limitations needs to be clearly documented somewhere.
> Usually an user thinks that only she can access encrypted files...
> 
> Thanks,
> //richard

For what it's worth, I've been making a few updates to the public design
document for ext4 encryption based on what's actually upstream now:

https://docs.google.com/document/d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg

It still needs work, though.  It doesn't really answer the questions about
access control and key revocation, for example, and of course now the upstream
code isn't actually ext4 specific anymore.

At some point it might be nice to write some in-tree documentation for fscrypto,
e.g. a file Documentation/filesystems/fscrypto.txt.

Eric
