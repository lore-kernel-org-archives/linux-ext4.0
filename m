From: Felipe A Rodriguez <far@illumenos.com>
Subject: Re: Possible regression in e2fsprogs-1.43.4
Date: Sat, 24 Jun 2017 21:08:46 +0200
Message-ID: <048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com> <20170623195318.cfs4ftpmy5nhcccy@thunk.org> <20170623232935.13fa4688@leda>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9EB954FA-2A4D-4753-A927-47B5F0F98293"; protocol="application/pkcs7-signature"; micalg=sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        linux-ext4@vger.kernel.org
To: Christian Hesse <list@eworm.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.illumenos.com ([46.101.240.157]:58195 "EHLO
        mail.illumenos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbdFXTJH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Jun 2017 15:09:07 -0400
In-Reply-To: <20170623232935.13fa4688@leda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9EB954FA-2A4D-4753-A927-47B5F0F98293
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Jun 23, 2017, at 11:29 PM, Christian Hesse <list@eworm.de> wrote:

> Theodore Ts'o <tytso@mit.edu> on Fri, 2017/06/23 15:53:
>> +grub-devel
>>=20
>> On Sat, Jun 10, 2017 at 04:00:20PM +0200, Felipe A Rodriguez wrote:
>>> Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes the boot
>>> loader to fail (unknown filesystem error) on the x86_64 VM I use for
>>> initial testing.  I traced the problem to changes in the e2fsprogs
>>> configuration file which now sets 64 bit flags.  I tried upgrading
>>> to GRUB 2.02 but that did not resolve the problem.  Reverting the
>>> changes per the patch below fixes the problem. =20
>>=20
>> Hmm, my laptop has been using a file system with the 64-bit feature
>> enabled for quite some time, and my Debian Stretch system has been
>> using Grub 2.02 to boot my system without any difficulties.
>>=20
>> I've done a quick check of the Debian patches and none of them seem =
to
>> modify Grub's ext2/ext4 file system implementation.  So I don't know
>> what to tell you.  Are you sure you properly reinstalled grub on the
>> boot device after you upgraded to grub 2.02?
>=20

Yes.  I did not upgrade the test VM directly.  I replaced GRUB 2.00 with =
2.02 in my build automation which creates an installer ISO.  =
Installation onto the VM is also largely automated.  GRUB 2.02 (and =
2.00) work fine if I revert the config file to that in 1.42.13. =20

To be clear:  I don=92t believe any of the code changes between 1.42.13 =
and 1.43.4 cause this issue.  The problem arises from just the changes =
in the built-in default configuration file that gets installed.  A =
distro that uses its own custom configuration file may not encounter =
this issue.  =20


> Grub should be fine, however syslinux still suffers issues with 64-bit
> feature. Possibly you use a chain to load syslinux first, grub second?

Yes, my test VM is configured to chain load GRUB from Syslinux =
(ISOLINUX).  I don=92t recall whether I tried booting directly into GRUB =
so I will test that tomorrow.





Regards,

Felipe


--Apple-Mail=_9EB954FA-2A4D-4753-A927-47B5F0F98293
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNzA2MjQxOTA4NDZaMCMGCSqGSIb3DQEJBDEW
BBQo+CSioj5x/3UFoph5rj+b9eWZnDANBgkqhkiG9w0BAQEFAASBgBd3D42RIvUP+UBgshhC9Zp2
dcS6wbRWCnOEhHjoSoj8rojzqpZ8LCG/M2rCqrxbnAXv75zfVfQZg7GjKlBfJ1TIYlwfsrjDzaPF
RIIyr2DuuqYJwfe0eHB0wL/3p4S30dJ+ROYVNEgA0SF8ZCmuam+BNKR0J7Mt8DXNK7oQT2HaAAAA
AAAA

--Apple-Mail=_9EB954FA-2A4D-4753-A927-47B5F0F98293--
