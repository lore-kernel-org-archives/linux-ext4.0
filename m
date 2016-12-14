From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [GIT PULL] ext4 updates for 4.10
Date: Wed, 14 Dec 2016 13:49:29 -0500
Message-ID: <20161214184929.GA14751@cmpxchg.org>
References: <20161213200007.jczekmqmtknxkfix@thunk.org>
 <CA+55aFzpr1r7MywLFGNyxRSkzwj7G8N2AdGNM22-poLMMv5QQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzpr1r7MywLFGNyxRSkzwj7G8N2AdGNM22-poLMMv5QQw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 14, 2016 at 09:20:43AM -0800, Linus Torvalds wrote:
> [ Johannes added to participants due to radix tree changes ]
> 
> On Tue, Dec 13, 2016 at 12:00 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > This merge request includes the dax-4.0-iomap-pmd branch which is
> > needed for both ext4 and xfs dax changes to use iomap for DAX.  It
> > also includes the fscrypt branch which is needed for ubifs encryption
> > work as well as ext4 encryption and fscrypt cleanups.
> 
> Can you double-check my merge resolution with the radix tree changes
> wrt the DAX changes, please? It looked straightforward, but it's an
> area where I'd really like people to actually look again and test..

The radix tree bits look correct to me.
