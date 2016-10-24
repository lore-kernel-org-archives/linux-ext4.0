From: Karel Zak <kzak@redhat.com>
Subject: Re: [RFD] Common userspace tool for fscypto
Date: Mon, 24 Oct 2016 14:49:37 +0200
Message-ID: <20161024124937.bxohuapjqns3m2dy@ws.net.home>
References: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 19, 2016 at 01:35:54PM +0200, Richard Weinberger wrote:
> Hi!
> 
> Since file level encryption has more than one user, currently ext4, f2fs and soon ubifs
> it would be nice to have a single tool to control fscrypto from userspace.
> 
> For ext4 we have already at least two tools, one as part of e2fsprogs and another
> one on github[0]. IMHO the latter one is much more user friendly and intuitive to use.
> I as unable to find the userspace tool for f2fs.
> 
> That said, what about implementing such a tool as part of util-linux to control
> fscrypto? We (David and I) would volunteer.

I have nothing against this plan (add to util-linux) if ext4, f2fs and
ubifs guys agree too.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
