From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/3] 2.6.23-rc6: known regressions v2
Date: Sat, 15 Sep 2007 04:29:05 +0200
Message-ID: <46EB4371.307__15701.0819217705$1189823386$gmane$org@googlemail.com>
References: <46EB3E94.7080704@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: jfs-discussion@lists.sourceforge.net,
	Oliver Neukum <oliver@neukum.org>, Florian Lohoff <flo@rfc822.org>,
	linux-usb-devel@lists.sourceforge.net, Shish <shish@shishnet.org>,
	sct@redhat.com, Karl Meyer <adhocrocker@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	Andy Whitcroft <apw@shadowen.org>, linux-fsdevel@vger.kernel.org,
	Daniel Drake <dsd@gentoo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	=?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <46EB3E94.7080704@googlemail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Sender: jfs-discussion-bounces@lists.sourceforge.net
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc6.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            10
Andi Kleen                             7
Linus Torvalds                         6
Alan Stern                             5
Hugh Dickins                           5
Trond Myklebust                        5
Andrew Morton                          4
David S. Miller                        4
Al Viro                                3
Alexey Starikovskiy                    3
Cornelia Huck                          3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



FS

Subject         : hanging ext3 dbench tests
References      : http://lkml.org/lkml/2007/9/11/176
Last known good : ?
Submitter       : Andy Whitcroft <apw@shadowen.org>
Caused-By       : ?
Handled-By      : ?
Status          : under test -- unreproducible at present

Subject         : umount triggers a warning in jfs and takes almost a minute
References      : http://lkml.org/lkml/2007/9/4/73
Last known good : ?
Submitter       : Oliver Neukum <oliver@neukum.org>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Networking

Subject         : build #301 failed for 2.6.23-rc6-g0d4cbb5 in linux/driver=
s/net/wireless/libertas/
References      : http://lkml.org/lkml/2007/9/11/150
Last known good : ?
Submitter       : Toralf F=F6rster <toralf.foerster@gmx.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : zd1211rw regression, device does not enumerate
References      : http://marc.info/?l=3Dlinux-usb-devel&m=3D118854967709322=
&w=3D2
                  http://bugzilla.kernel.org/show_bug.cgi?id=3D8972
Last known good : ?
Submitter       : Oliver Neukum <oliver@neukum.org>
Caused-By       : Daniel Drake <dsd@gentoo.org>
                  commit 74553aedd46b3a2cae986f909cf2a3f99369decc
Handled-By      : ?
Status          : unknown

Subject         : NETDEV WATCHDOG: eth0: transmit timed out
References      : http://lkml.org/lkml/2007/8/13/737
Last known good : ?
Submitter       : Karl Meyer <adhocrocker@gmail.com>
Caused-By       : ?
Handled-By      : Francois Romieu <romieu@fr.zoreil.com>
Status          : problem is being debugged

Subject         : Weird network problems with 2.6.23-rc2
References      : http://lkml.org/lkml/2007/8/11/40
Last known good : ?
Submitter       : Shish <shish@shishnet.org>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Farewell!
Michal

--
LOGOUT
http://www.stardust.webpages.pl/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
