From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Thu, 6 Oct 2016 12:17:15 +1100
Message-ID: <20161006011714.GT27872@dastard>
References: <20161005170659.GA110549@google.com>
 <20161005182307.GA1164@google.com>
 <5c01fd8e-95e6-669c-9f9d-30ab5a7af9fd@nod.at>
 <ac10ada8-40fc-e946-7593-efa08eb875d1@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Halcrow <mhalcrow@google.com>,
        David Gstir <david@sigma-star.at>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Anand Jain <anand.jain@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac10ada8-40fc-e946-7593-efa08eb875d1@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 05, 2016 at 11:14:55PM +0200, Richard Weinberger wrote:
> Michael,
> 
> On 05.10.2016 20:44, Richard Weinberger wrote:
> > Well, let's focus first on file contents.
> > We have already the fscrypo framework.
> > 
> > What you suggest is completely different from what we have now.
> 
> To clarify that, I'm not saying that meta-data or block level authentication
> is a bad idea. But let's start with small steps and consider file contents
> authentication first. Of course this has some attack vectors but these
> can be documented and for many use case these are acceptable.

This is the sanest approach, because encrypting filesystem internal
metadata may have some unintended consequences. e.g being unable to
perform forensic analysis of corruption or data loss events, or an
inability for tools like fsck to work without also implementing all
the encryption code in userspace and being provided with all the
keys needed to decrypt the metadata.

i.e. it's not just the kernel code we have to consider here when
discussing this level of encryption in filesystems - the impact
on the entire support ecosystem needs to be considered. A weakness
in a fsck tool will be just as serious as a weakness in the kernel
code, and there's a much larger amount of widely dispersed code that
would need to be encryption enabled by going down this path.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
