From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [RFC PATCH 02/10] fs-verity: add data verification
 hooks for ->readpages()
Date: Fri, 24 Aug 2018 23:45:44 -0400
Message-ID: <20180825034544.GA5281@thunk.org>
References: <20180824161642.1144-1-ebiggers@kernel.org>
 <20180824161642.1144-3-ebiggers@kernel.org>
 <2f2382c3-e5e9-f0da-dc89-42dfc7b2b636@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Michael Halcrow <mhalcrow@google.com>, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, Eric Biggers <ebiggers@kernel.org>,
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org,
 Mimi Zohar <zohar@linux.vnet.ibm.com>, Victor Hsieh <victorhsieh@google.com>
To: Gao Xiang <gaoxiang25@huawei.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <2f2382c3-e5e9-f0da-dc89-42dfc7b2b636@huawei.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 25, 2018 at 10:29:26AM +0800, Gao Xiang wrote:
> 
> My first question is that 'Is there any way to skip to verify pages in a bio?'
> I am thinking about
> If metadata and data page are mixed in a filesystem of such kind, they could submit together in a bio, but metadata could be unsuitable for such kind of verification.
> 
> The second question is related to the first question --- 'Is there any way to verify a partial page?'
> Take scalability into consideration, some files could be totally inlined or partially inlined in metadata.
> Is there any way to deal with them in per-file approach? at least --- support for the interface?

A requirement of both fscrypt and fsverity is that is that block size
== page size, and that all data is stored in blocks.  Inline data is
not supported.

The files that are intended for use with fsverity are large files
(such as APK files), so optimizing for files smaller than a block was
not a design goal.

					- Ted

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
