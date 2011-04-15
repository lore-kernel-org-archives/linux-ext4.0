From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Fri, 15 Apr 2011 16:28:37 -0600
Message-ID: <DD59E27A-FD96-4983-A274-B76CCE99AE7A@dilger.ca>
References: <20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
	<87sjtjq4ir.fsf@rho.meyering.net>
	<20110415171629.GA9088@infradead.org> <4DA87F43.5040807@redhat.com>
	<20110415172603.GA20086@infradead.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>,
	xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, coreutils-mXXj517/zsQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <20110415172603.GA20086-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <http://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2011-04-15, at 11:26 AM, Christoph Hellwig wrote:
> On Fri, Apr 15, 2011 at 11:24:19AM -0600, Eric Blake wrote:
>> Would it be worth borrowing from Solaris' semantics and adding =
SEEK_HOLE
>> and SEEK_DATA to lseek(2), as a higher level (less-detailed, but =
easier
>> to define and easier to use) interface for discovering the regions of =
a
>> file that only contain NUL bytes?
>=20
> Yes, I've already suggested that both in this thread and on IRC.
>=20
> For efficient copies it's the only usable interface.

I suspect that these bugs would have still existed whether the interface =
is SEEK_HOLE/SEEK_DATA, or FIEMAP.  The main problem is that the =
delalloc pages were not accounted for correctly during layout traversal.

For ext4 I think it is sufficient to add another case to =
ext4_ext_fiemap_cb() to check the pagecache for unmapped pages when it =
finds an uninitialized extent on disk.  This will be very similar to the =
fix for finding holes in the on-disk mapping.

Cheers, Andreas
