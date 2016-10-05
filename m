From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Wed, 5 Oct 2016 23:14:55 +0200
Message-ID: <ac10ada8-40fc-e946-7593-efa08eb875d1@nod.at>
References: <20161005170659.GA110549@google.com>
 <20161005182307.GA1164@google.com>
 <5c01fd8e-95e6-669c-9f9d-30ab5a7af9fd@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Anand Jain <anand.jain@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>
To: Michael Halcrow <mhalcrow@google.com>,
        David Gstir <david@sigma-star.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <5c01fd8e-95e6-669c-9f9d-30ab5a7af9fd@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Michael,

On 05.10.2016 20:44, Richard Weinberger wrote:
> Well, let's focus first on file contents.
> We have already the fscrypo framework.
> 
> What you suggest is completely different from what we have now.

To clarify that, I'm not saying that meta-data or block level authentication
is a bad idea. But let's start with small steps and consider file contents
authentication first. Of course this has some attack vectors but these
can be documented and for many use case these are acceptable.

Thanks,
//richard
