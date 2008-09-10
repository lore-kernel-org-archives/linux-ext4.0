From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Date: Wed, 10 Sep 2008 09:57:08 -0500
Message-ID: <48C7E044.2050406@redhat.com>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org> <20080910114011.GB3757@localhost.localdomain> <20080910114042.GA15996@infradead.org> <20080910114923.GC3757@localhost.localdomain> <48C7CDF4.2020206@redhat.com> <20080910134700.GI3757@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753872AbYIJPAb@vger.kernel.org>
In-Reply-To: <20080910134700.GI3757@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kirill A. Shutemov wrote:
> On Wed, Sep 10, 2008 at 08:39:00AM -0500, Eric Sandeen wrote:

>> I think it does not.
> 
> It does:
> 
> $ grep unifdef-y include/linux/Kbuild | grep ext2
> unifdef-y += ext2_fs.h

Oops, I stand corrected :)

-Eric
