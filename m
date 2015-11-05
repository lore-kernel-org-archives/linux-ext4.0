From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Ext4: Fix extended timestamp encoding and decoding
Date: Thu, 05 Nov 2015 15:53:01 +0100
Message-ID: <5018017.G1d6XcMJ5z@wuerfel>
References: <20151105144916.6333.58880.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: tytso@mit.edu, kalpak@clusterfs.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151105144916.6333.58880.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 05 November 2015 14:49:16 David Howells wrote:
> Since the epoch is presumably unsigned, this has the slightly strange
> effect of, for epochs > 0, putting the 0x80000000-0xffffffff range before
> the 0x00000000-0x7fffffff range.
>
> This affects all kernels from v2.6.23-rc1 onwards.

...

> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Maybe
Cc: stable@vger.kernel.org # v2.6.23+
