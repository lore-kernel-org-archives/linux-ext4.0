From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v3] fscrypt: add a documentation file for
 filesystem-level encryption
Date: Mon, 9 Oct 2017 13:33:33 -0700
Message-ID: <20171009203333.GC67463@gmail.com>
References: <20170909001512.72431-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@google.com>, linux-doc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, linux-fscrypt@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20170909001512.72431-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 08, 2017 at 05:15:12PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Perhaps long overdue, add a documentation file for filesystem-level
> encryption, a.k.a. fscrypt or fs/crypto/, to the Documentation
> directory.  The new file is based loosely on the latest version of the
> "EXT4 Encryption Design Document (public version)" Google Doc, but with
> many improvements made, including:
> 
> - Reflect the reality that it is not specific to ext4 anymore.
> - More thoroughly document the design and user-visible API/behavior.
> - Replace outdated information, such as the outdated explanation of how
>   encrypted filenames are hashed for indexed directories and how
>   encrypted filenames are presented to userspace without the key.
>   (This was changed just before release.)
> 
> For now the focus is on the design and user-visible API/behavior, not on
> how to add encryption support to a filesystem --- since the internal API
> is still pretty messy and any standalone documentation for it would
> become outdated as things get refactored over time.
> 
> Reviewed-by: Michael Halcrow <mhalcrow@google.com>

Ted, are you interested in taking this through the fscrypt tree for v4.15?

Eric

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
