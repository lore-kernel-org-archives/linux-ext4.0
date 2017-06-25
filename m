From: Felipe A Rodriguez <far@illumenos.com>
Subject: Re: Possible regression in e2fsprogs-1.43.4  [RESOLVED]
Date: Sun, 25 Jun 2017 20:16:39 +0200
Message-ID: <F43FD2C9-608B-4D5E-A61A-749993688E61@illumenos.com>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com>
	<20170623195318.cfs4ftpmy5nhcccy@thunk.org>
	<20170623232935.13fa4688@leda>
	<048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com>
Reply-To: The development of GNU GRUB <grub-devel@gnu.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/mixed; boundary="===============7597718788585714168=="
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
 Christian Hesse <list@eworm.de>
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
In-Reply-To: <048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com>
List-Unsubscribe: <https://lists.gnu.org/mailman/options/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/archive/html/grub-devel/>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
Sender: "Grub-devel" <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
List-Id: linux-ext4.vger.kernel.org


--===============7597718788585714168==
Content-Type: multipart/signed; boundary="Apple-Mail=_42438AC5-5075-40C2-A9E6-3D6A7818912E"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_42438AC5-5075-40C2-A9E6-3D6A7818912E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Jun 24, 2017, at 9:08 PM, Felipe A Rodriguez <far@illumenos.com> =
wrote:

> On Jun 23, 2017, at 11:29 PM, Christian Hesse <list@eworm.de> wrote:
>=20
>> Theodore Ts'o <tytso@mit.edu> on Fri, 2017/06/23 15:53:
>>> +grub-devel
>>>=20
>>> On Sat, Jun 10, 2017 at 04:00:20PM +0200, Felipe A Rodriguez wrote:
>>>> Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes the =
boot
>>>> loader to fail (unknown filesystem error) on the x86_64 VM I use =
for
>>>> initial testing.  I traced the problem to changes in the e2fsprogs
>>>> configuration file which now sets 64 bit flags.  I tried upgrading
>>>> to GRUB 2.02 but that did not resolve the problem.  Reverting the
>>>> changes per the patch below fixes the problem. =20
>>>=20
>>> Hmm, my laptop has been using a file system with the 64-bit feature
>>> enabled for quite some time, and my Debian Stretch system has been
>>> using Grub 2.02 to boot my system without any difficulties.
>>>=20
>>> I've done a quick check of the Debian patches and none of them seem =
to
>>> modify Grub's ext2/ext4 file system implementation.  So I don't know
>>> what to tell you.  Are you sure you properly reinstalled grub on the
>>> boot device after you upgraded to grub 2.02?
>>=20
>=20
> Yes.  I did not upgrade the test VM directly.  I replaced GRUB 2.00 =
with 2.02 in my build automation which creates an installer ISO.  =
Installation onto the VM is also largely automated.  GRUB 2.02 (and =
2.00) work fine if I revert the config file to that in 1.42.13. =20
>=20
> To be clear:  I don=92t believe any of the code changes between =
1.42.13 and 1.43.4 cause this issue.  The problem arises from just the =
changes in the built-in default configuration file that gets installed.  =
A distro that uses its own custom configuration file may not encounter =
this issue.  =20
>=20
>=20
>> Grub should be fine, however syslinux still suffers issues with =
64-bit
>> feature. Possibly you use a chain to load syslinux first, grub =
second?
>=20
> Yes, my test VM is configured to chain load GRUB from Syslinux =
(ISOLINUX).  I don=92t recall whether I tried booting directly into GRUB =
so I will test that tomorrow.
>=20

Sysllinux chain-loading is not a factor (GRUB 2.00 still fails to boot =
w/o it).  GRUB 2.02 does resolve the issue.  The command line for 2.02 =
required a =93-p=94 switch which 2.00 does not.  This probably caused an =
uncaught and unnoticed failure during installation in my previous =
testing.


Regards,

Felipe




--Apple-Mail=_42438AC5-5075-40C2-A9E6-3D6A7818912E
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIICfzCCAnsw
ggHkoAMCAQICCqanDr1kz71qujMwDQYJKoZIhvcNAQEFBQAwbjEZMBcGA1UEAxMQRmVsaXBlIFJv
ZHJpZ3VlejETMBEGA1UEChMKRkJBUiBmaWxlcjENMAsGA1UECxMERkJBUjEgMB4GCSqGSIb3DQEJ
ARYRZmFyQGlsbHVtZW5vcy5jb20xCzAJBgNVBAYTAlVTMB4XDTE0MDIyMjIxMDcyNFoXDTE5MDIy
MjIxMDcyNFowbjEZMBcGA1UEAxMQRmVsaXBlIFJvZHJpZ3VlejETMBEGA1UEChMKRkJBUiBmaWxl
cjENMAsGA1UECxMERkJBUjEgMB4GCSqGSIb3DQEJARYRZmFyQGlsbHVtZW5vcy5jb20xCzAJBgNV
BAYTAlVTMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgPLXDCrdOkVKK2699h0EDXjw1+eRJ
Q8q7sMKF8DgriyscXRCCDMwn+FlE32VZFMwBorYHxG7Y5rHV92Rw1Vo5/miyOm9yBC0SJ0AZL5CL
sl10walw2x14YtLJx23QyMLrjIfN5SNYYNMer53Cx5G5bsfhXtxT4RTDH0TfgoEQAQIDAQABoyAw
HjAPBgkqhkiG9y8BAQoEAgUAMAsGA1UdDwQEAwIDmDANBgkqhkiG9w0BAQUFAAOBgQA2J7u2FSZr
jgKJk8moqKjQHW8OiD0lR5nSCAK1KPWiHX2Lqp4Rf7tBGnHXkW6PqC2bNcSJelmJnl3cHHb65A8x
GWBx1euk1GPiX1wWYXufnMzVdE+yIb1CB+spbEZEFivwqwacxC3wh7CRC3Ar8EHO6f2SMKNzzGFI
RlRdlDzpcjGCAYEwggF9AgEBMHwwbjEZMBcGA1UEAxMQRmVsaXBlIFJvZHJpZ3VlejETMBEGA1UE
ChMKRkJBUiBmaWxlcjENMAsGA1UECxMERkJBUjEgMB4GCSqGSIb3DQEJARYRZmFyQGlsbHVtZW5v
cy5jb20xCzAJBgNVBAYTAlVTAgqmpw69ZM+9arozMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNzA2MjUxODE2MzlaMCMGCSqGSIb3DQEJBDEW
BBTJ5Stno2DUzq3M3bNfR8X4ofptuDANBgkqhkiG9w0BAQEFAASBgIuaeuJ7A3GrwDw9DJz6+GVS
TPqKk4YnWe5sX2d/0I4CZaw/u+FW/WGJ2bKwllg8hir1vXTjGmpf9PBwvS17W4J+ESxRk+BX6kSG
LBHrDxB0ykcbllO+U/uPHrCclJnzoOZJWusHvTvxEjmTm1//TdBfcTZXNEMOy6qQp+xY1ZJIAAAA
AAAA

--Apple-Mail=_42438AC5-5075-40C2-A9E6-3D6A7818912E--


--===============7597718788585714168==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Grub-devel mailing list
Grub-devel@gnu.org
https://lists.gnu.org/mailman/listinfo/grub-devel

--===============7597718788585714168==--
