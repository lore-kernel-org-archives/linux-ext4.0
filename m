From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 3/6] ubifs: Use 64bit readdir cookies
Date: Thu, 29 Dec 2016 11:15:34 -0500
Message-ID: <20161229161534.GA29261@fieldses.org>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
 <1480629741-18375-4-git-send-email-richard@nod.at>
 <20161229025835.GC21325@fieldses.org>
 <bf60916c-e0f2-387c-ce21-325ad8977539@nod.at>
 <20161229153407.GA29149@fieldses.org>
 <fe46ea3c-ef8f-40ba-f4ab-8dfe8faafb0b@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: david@sigma-star.at, tytso@mit.edu, dedekind1@gmail.com,
 adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 adilger.kernel@dilger.ca, akpm@linux-foundation.org,
 linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <fe46ea3c-ef8f-40ba-f4ab-8dfe8faafb0b@nod.at>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 29, 2016 at 04:49:54PM +0100, Richard Weinberger wrote:
> Bruce,
> 
> On 29.12.2016 16:34, J. Bruce Fields wrote:
> >> That way UBIFS can provide a 64bit readdir() cookie which is required for NFS3.
> > 
> > Sounds good.  And if a matching entry isn't found (as in the case of a
> > concurrent unlink), what happens?  The answer must be the same as for
> > ext4, but I've forgotten the details....  I guess it must find the next
> > highest cookie (thinking of the cookie as a 64-bit integer of some kind)
> > that exists in the directory.  And that must be the same order that
> > readdir normally returns entries in.
> 
> If a 64bit cookie is not found, the lookup function returns -ENOENT.
> In UBIFS we cannot just select a higher or lower key (cookie in this case),
> since it is the B-tree key and would point to a completely different
> entry.
> 
> So, in case of a concurrent unlink() one would succeed and one fail with
> -ENOENT. Unless I miss something that seems okay to me.

Unlink takes (parent directory, name), not a directory cookie.

The problem is concurrent unlink and nfs readdir.  So:

	NFS server returns readdir result with cookie X

	Somebody unlinks the entry at X.

	NFS server gets readdir request with cookie X.

Then the NFS client will get a spurious -ENOENT.

I'm not sure how best to reproduce that.... Maybe:

	Create a directory on an nfs-exported filesystem with lots of
	entries.

	Start a loop (or loops?) renaming directory entries within the
	directory as fast as possible (or deleting and creating entries;
	I assume it's the same thing for our purposes).

	read the directory from an nfs client.

I'm not sure how many entries is "lots".... Ideally you want a single
read of the directory to require the client to make lots of READDIR
requests to the server.  You could help by running:

	echo 1024 >/proc/fs/nfsd/max_block_size

before starting knfsd.  That should force it to return no more than 1K
of data in each READDIR reply.

--b.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
