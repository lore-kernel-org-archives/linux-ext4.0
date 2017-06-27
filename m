From: Felipe A Rodriguez <far@illumenos.com>
Subject: Re: Possible regression in e2fsprogs-1.43.4  [RESOLVED]
Date: Tue, 27 Jun 2017 13:58:44 +0200
Message-ID: <ECAB3A47-1686-4D31-B26E-6930DFB31B0E@illumenos.com>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com> <20170623195318.cfs4ftpmy5nhcccy@thunk.org> <20170623232935.13fa4688@leda> <048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com> <F43FD2C9-608B-4D5E-A61A-749993688E61@illumenos.com> <20170626024019.hni2k6uwfb7sknaw@thunk.org> <53DF6A08-AA60-4A9C-BD29-46475DAB528A@illumenos.com> <20170627015338.5heipzrsmp4dwsmd@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_895D1C20-CED1-4B1A-B656-585D002DBF58"; protocol="application/pkcs7-signature"; micalg=sha1
Cc: Christian Hesse <list@eworm.de>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.illumenos.com ([46.101.240.157]:58216 "EHLO
        mail.illumenos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdF0L7P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 07:59:15 -0400
In-Reply-To: <20170627015338.5heipzrsmp4dwsmd@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_895D1C20-CED1-4B1A-B656-585D002DBF58
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 27, 2017, at 3:53 AM, Theodore Ts'o <tytso@mit.edu> wrote:

> On Mon, Jun 26, 2017 at 08:46:48AM +0200, Felipe A Rodriguez wrote:
>>> So when you say that enabling the 64-bit file system feature causes =
a
>>> regression by causing Grub to fail to be able to read the root file
>>> system, I have to respectfully disagree.  I do it all the time when =
I
>>> reboot my kernel, and it Works For Me...
>>=20
>> Huh ???  I indicated GRUB 2.00 stopped working with the upgrade to =
1.43.4, but GRUB 2.02 works fine.
>=20
> You originally said:
>=20
> On Sat, Jun 10, 2017 at 04:00:20PM +0200, Felipe A Rodriguez wrote:
>> Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes the boot
>> loader to fail (unknown filesystem error) on the x86_64 VM I use for
>> initial testing.  I traced the problem to changes in the e2fsprogs
>> configuration file which now sets 64 bit flags.  I tried upgrading
>> to GRUB 2.02 but that did not resolve the problem.
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> In your follow up, you didn't bother line wrapping your message, so I
> misparsed the sentence where you stated "Grub 2.02 does resolve the
> problem" because it was burried in a several hundred character long
> line.  My apologies.
>=20
> 					- Ted

No problem.  My thanks to you and all others who contributed to =
e2fsprogs and GRUB dev.


Felipe


--Apple-Mail=_895D1C20-CED1-4B1A-B656-585D002DBF58
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNzA2MjcxMTU4NDVaMCMGCSqGSIb3DQEJBDEW
BBQ+SjbOFpkU7i1yJUTb1Eq/rPDEwDANBgkqhkiG9w0BAQEFAASBgGuIw2tflZIHIRGbJlzMp5YM
feDz8/RKHLc8PvdyqUzHyxVSwf9C9rXrvWGBGf+lezb221pANwXKZx/XLd4O/RgRn+WRkHL45kM0
1jB8t3QFBZsD8fzYszrXgdLzqXZ3dGNNdRGKySZkmcb/zdyaCvijfwipCx9gF5UgywQVmpeuAAAA
AAAA

--Apple-Mail=_895D1C20-CED1-4B1A-B656-585D002DBF58--
