From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2] iversion: make inode_cmp_iversion{+raw} return bool
 instead of s64
Date: Wed, 31 Jan 2018 07:29:22 -0500
Message-ID: <1517401762.3612.0.camel@kernel.org>
References: <20180130173126.2806-1-jlayton@kernel.org>
         <20180130203221.29310-1-jlayton@kernel.org>
         <CA+55aFw5Xf4V-BF1JK+SpjXnmrgeMe-k0wLaFc_=6ojbhfWEtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Trond Myklebust <trondmy@primarydata.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw5Xf4V-BF1JK+SpjXnmrgeMe-k0wLaFc_=6ojbhfWEtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2018-01-30 at 12:53 -0800, Linus Torvalds wrote:
> Ack. Should I expect this in a future pull request, or take it directly?
> 
> There's no hurry about this, since none of the existing users of that
> function actually do anything but test the return value against zero,
> and nobody saves it into anything but a "bool" (which has magical
> casting properties and does not lose upper bits).
> 
>               Linus

Do you mind just taking it directly? I don't have anything else queued
up for this cycle.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
