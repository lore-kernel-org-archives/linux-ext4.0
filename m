From: Rudolf Zran <rudolfzran@yahoo.com>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Thu, 9 Feb 2012 21:22:23 +0000 (GMT)
Message-ID: <1328822543.65833.YahooMailNeo@web132404.mail.ird.yahoo.com>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com> <ADF9EEFE-188A-4E88-BA8E-45D2607B1F3B@dilger.ca>
Reply-To: Rudolf Zran <rudolfzran@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
  "debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <bounce-debian-user=gldu-debian-user-2=m.gmane.org@lists.debian.org>
In-Reply-To: <ADF9EEFE-188A-4E88-BA8E-45D2607B1F3B@dilger.ca>
Resent-Message-ID: <1lLuznQbZxC.A._xB.KlDNPB@liszt>
List-Post: <mailto:debian-user@lists.debian.org>
List-Help: <mailto:debian-user-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-user-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-user-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

Hello Andreas!=0A=0A=0A[ext4 partition overwritten with garbage at the begi=
nning]=0A=0A=0A>>  * photorec from the testdisk package recoveres, luckily!=
, about 500GB of=0A>> =A0  data. Though the content seems to be pretty reas=
onable, no filenames=0A>> =A0  are recovered, since photorec operates witho=
ut using filesystem =0A>> =A0 knowledge.=0A>> =0A>>  Do you see any chances=
 (besides consulting professional recovery companies)=0A>>  getting the fil=
enames back?=0A> =0A> There was an ext3grep tool that some people had succe=
ss with, but when I=0A> looked at it, it was still fairly complex to use.=
=0A=0AThanks for the hint, but the problem with ext3grep is that it seems t=
o=0Arely on an intact filesystem structure. It even has no option to set=0A=
another superblock besides the default one and fails with all commands=0AI =
tried ( see https://pzt.me/8q6k ).=0A=0ABye, Rudolf.=0A
