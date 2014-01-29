From: Kodiak Furr <boxerapp@aol.com>
Subject: Re: [PATCH] xfstests: avoid ext4/306 failures caused by
	incompatible mount options
Date: Wed, 29 Jan 2014 15:48:32 -0600
Message-ID: <8B7AA21A-D30B-41BE-A381-85C4D8E08791@aol.com>
References: <20140129213838.GF30419@thunk.org>
 <52E9761F.7070903@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8316982329936314321=="
Cc: linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com
To: <sandeen@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <52E9761F.7070903@redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

--===============8316982329936314321==
Content-Type: multipart/alternative; boundary="52e97730_327b23c6_1023"

--52e97730_327b23c6_1023
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Kodiak =46urr liked your message with Boxer. On January 29, 2014 at 3:43:=
59 PM CST, Eric Sandeen  wrote:On 1/29/14, 3:38 PM, Theodore Ts'o wrote:>=
 On Wed, Jan 29, 2014 at 03:45:02PM -0500, Eric Whitney wrote:>> ext4/306=
 will fail when mounting the ext3 file system it creates if an>> ext3-inc=
ompatible mount option is applied by =5Fscratch=5Fmount. This can>> happe=
n if EXT=5FMOUNT=5FOPTIONS is defined appropriately in the test>> environ=
ment. =46or example, the block=5Fvalidity option is commonly used>> to en=
hance ext4 testing, and it is not supported by ext3. =46ix this by>> not =
including any mount options defined by the test environment.> > I'm not s=
ure I understand why the test is insisting that the file> system be mount=
ed using ext3. If the file system is created without> the extents flag, a=
ll of the files will be created using indirect> blocks, and fundamentally=
 what this test is getting at is that after> we grow the file system usin=
g resize2fs, the new blocks are available> to be allocated and attached t=
o an indirect block file.> > We can do this by using ext4; I'm not sure w=
hy this test is trying to> use ext3 to set up the test flie system. It mi=
ght be better to get> rid of the requirement to create the file system us=
ing ext3, since it> will make the test runnable even if the ext3 file sys=
tem hasn't been> configured into the system and CON=46IG=5FEXT23=5FAS=5FE=
XT4 is not enabled.> > IIRC, Eric Sandeen wrote this test --- Eric, am I =
missing some reason> why it was necessary to use ext3 here=3FNope. Tomayt=
o, tomahto - I think the original report had trouble withan ext3 filesyst=
em, so that's how I wrote the testcase.It could be fixed either way, I th=
ink.-Eric> > - Ted> --To unsubscribe from this list: send the line =22uns=
ubscribe linux-ext4=22 inthe body of a message to majordomo=40vger.kernel=
.orgMore majordomo info at http://vger.kernel.org/majordomo-info.html    =
 
--52e97730_327b23c6_1023
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<html><body><div>Kodiak =46urr liked your message with <a href=3D=22http:=
//ad.apps.fm/x3NHJParL2cT9cQ9WcgT1xM8G1T=5FLUvoWYXredpuoYBLq62ptJqsuhqD23=
uAmN=5FARL=5FcKzXIyDOjqo=5F2b16qX20uaphn=46WU7uPwUiYWuOAT=46UAGQB7Cox3TWT=
3ZKjzWyP=46IlhepnEZcRklQejqpibw=22>Boxer</a>.</div><br/><br/><div><div cl=
ass=3D=22quote=22>On January 29, 2014 at 3:43:59 PM CST, Eric Sandeen <es=
andeen=40redhat.com> wrote:<br/><blockquote type=3D=22cite=22 style=3D=22=
border-left-style:solid;border-width:1px;margin-left:0px;padding-left:10p=
x;=22>On 1/29/14, 3:38 PM, Theodore Ts'o wrote:<br />> On Wed, Jan 29, 20=
14 at 03:45:02PM -0500, Eric Whitney wrote:<br />>> ext4/306 will fail wh=
en mounting the ext3 file system it creates if an<br />>> ext3-incompatib=
le mount option is applied by =5Fscratch=5Fmount.  This can<br />>> happe=
n if EXT=5FMOUNT=5FOPTIONS is defined appropriately in the test<br />>> e=
nvironment.  =46or example, the block=5Fvalidity option is commonly used<=
br />>> to enhance ext4 testing, and it is not supported by ext3.  =46ix =
this by<br />>> not including any mount options defined by the test envir=
onment.<br />> <br />> I'm not sure I understand why the test is insistin=
g that the file<br />> system be mounted using ext3.  If the file system =
is created without<br />> the extents flag, all of the files will be crea=
ted using indirect<br />> blocks, and fundamentally what this test is get=
ting at is that after<br />> we grow the file system using resize2fs, the=
 new blocks are available<br />> to be allocated and attached to an indir=
ect block file.<br />> <br />> We can do this by using ext4; I'm not sure=
 why this test is trying to<br />> use ext3 to set up the test flie syste=
m.  It might be better to get<br />> rid of the requirement to create the=
 file system using ext3, since it<br />> will make the test runnable even=
 if the ext3 file system hasn't been<br />> configured into the system an=
d CON=46IG=5FEXT23=5FAS=5FEXT4 is not enabled.<br />> <br />> IIRC, Eric =
Sandeen wrote this test --- Eric, am I missing some reason<br />> why it =
was necessary to use ext3 here=3F<br /><br />Nope.  Tomayto, tomahto - I =
think the original report had trouble with<br />an ext3 filesystem, so th=
at's how I wrote the testcase.<br /><br />It could be fixed either way, I=
 think.<br /><br />-Eric<br /><br />> <br />> 					- Ted<br />> <br /><br=
 />--<br />To unsubscribe from this list: send the line =22unsubscribe li=
nux-ext4=22 in<br />the body of a message to majordomo=40vger.kernel.org<=
br />More majordomo info at  http://vger.kernel.org/majordomo-info.html<b=
r /></blockquote></div></div></body></html>
--52e97730_327b23c6_1023--


--===============8316982329936314321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8316982329936314321==--
