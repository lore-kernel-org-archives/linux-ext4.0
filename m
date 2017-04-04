From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] statx: Include a mask for stx_attributes in struct
 statx
Date: Tue, 4 Apr 2017 00:12:52 -0700
Message-ID: <20170404071252.GA30966@infradead.org>
References: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
 <149098153785.28108.1114055429564367803.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149098153785.28108.1114055429564367803.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 31, 2017 at 06:32:17PM +0100, David Howells wrote:
> Include a mask in struct stat to indicate which bits of stx_attributes the
> filesystem actually supports.

What's the use case for this?
