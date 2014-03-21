From: Samuel Thibault <sthibault@debian.org>
Subject: Bug#738758: [PATCH] ext4: optimize Hurd tests when reading/writing inodes
Date: Fri, 21 Mar 2014 18:11:14 +0100
Message-ID: <20140321171114.GA5601@type.youpi.perso.aquilenet.fr>
References: <20140321143927.GA31179@thunk.org>
 <1395420533-20103-1-git-send-email-tytso@mit.edu>
Reply-To: Samuel Thibault <sthibault@debian.org>, 738758@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
To: 738758@bugs.debian.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.738758.B738758.139542188531899@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <1395420533-20103-1-git-send-email-tytso@mit.edu>
List-URL: <http://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o, le Fri 21 Mar 2014 12:48:53 -0400, a =E9crit :
> Also, add a sanity check to make sure the 64-bit feature is not set
> for Hurd file systems, since i_file_acl_high conflicts with a
> Hurd-specific field. This is not a big deal, since Hurd doesn't
> support file systems larger than 1GB[1] anyway.

Err, it does. We regularly use volumes with dozens of GiB.

> [1] http://walfield.org/pub/people/neal/papers/hurd-faq/FAQ.en.html#q2-=
6

That faq is very largely outdated.  See the official faq on=20

http://www.gnu.org/software/hurd/faq.html

Samuel


--=20
To UNSUBSCRIBE, email to debian-bugs-dist-REQUEST@lists.debian.org
with a subject of "unsubscribe". Trouble? Contact listmaster@lists.debian=
.org
