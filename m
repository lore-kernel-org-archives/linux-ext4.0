From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/38] ext4: Define usercopy region in ext4_inode_cache
 slab cache
Date: Thu, 11 Jan 2018 12:01:19 -0500
Message-ID: <20180111170119.GB19241@thunk.org>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-14-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	"David S. Miller" <davem@davemloft.net>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>,
	Matthew Garrett <mjg59@goo
To: Kees Cook <keescook@chromium.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1515636190-24061-14-git-send-email-keescook@chromium.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 10, 2018 at 06:02:45PM -0800, Kees Cook wrote:
> The ext4 symlink pathnames, stored in struct ext4_inode_info.i_data
> and therefore contained in the ext4_inode_cache slab cache, need
> to be copied to/from userspace.

Symlink operations to/from userspace aren't common or in the hot path,
and when they are in i_data, limited to at most 60 bytes.  Is it worth
it to copy through a bounce buffer so as to disallow any usercopies
into struct ext4_inode_info?

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
