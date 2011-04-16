From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Fri, 15 Apr 2011 23:11:23 -0600
Message-ID: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
Mime-Version: 1.0 (iPhone Mail 8G4)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>, xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>,
	"coreutils-mXXj517/zsQ@public.gmane.org" <coreutils-mXXj517/zsQ@public.gmane.org>,
	"linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <20110416005040.GP21395@dastard>
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

On 2011-04-15, at 6:50 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> What you are suggesting is that FIEMAP needs to be page cache
> coherent, and that is far, far away from the intended use of the
> interface. Even consiering that you need to looking for active pages
> in the page cache when mapping extents say to me that you are
> doing something very wrong.
>=20
> Unwritten extents remain unwritten until the data is physically
> written to them. Therefore, to change their state, you need to sync
> the data covering the range.

In that case, it means cp should just always use FIEMAP_FLAG_SYNC, which is f=
ine.=20

Cheers, Andreas
