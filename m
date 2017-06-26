From: Felipe A Rodriguez <far@illumenos.com>
Subject: Re: Possible regression in e2fsprogs-1.43.4  [RESOLVED]
Date: Mon, 26 Jun 2017 08:46:48 +0200
Message-ID: <53DF6A08-AA60-4A9C-BD29-46475DAB528A@illumenos.com>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com> <20170623195318.cfs4ftpmy5nhcccy@thunk.org> <20170623232935.13fa4688@leda> <048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com> <F43FD2C9-608B-4D5E-A61A-749993688E61@illumenos.com> <20170626024019.hni2k6uwfb7sknaw@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_42C088CE-DF7B-44D8-BED9-1C0543DB610D"; protocol="application/pkcs7-signature"; micalg=sha1
Cc: Christian Hesse <list@eworm.de>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.illumenos.com ([46.101.240.157]:58209 "EHLO
        mail.illumenos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdFZGrM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 02:47:12 -0400
In-Reply-To: <20170626024019.hni2k6uwfb7sknaw@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_42C088CE-DF7B-44D8-BED9-1C0543DB610D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Jun 26, 2017, at 4:40 AM, Theodore Ts'o <tytso@mit.edu> wrote:

> On Sun, Jun 25, 2017 at 08:16:39PM +0200, Felipe A Rodriguez wrote:
>>=20
>> Sysllinux chain-loading is not a factor (GRUB 2.00 still fails to
>> boot w/o it).  GRUB 2.02 does resolve the issue.  The command line
>> for 2.02 required a =93-p=94 switch which 2.00 does not.  This =
probably
>> caused an uncaught and unnoticed failure during installation in my
>> previous testing.
>=20
> Again, Debian is using e2fsprogs 1.43.4 and uses ext4 as the default
> file system, and GRUB 2.02 as the default boot system.  No one has
> complained about failures in the instsall process, and I'm pretty sure
> the Debian installer team has done their usual great job in testing
> and QA.  So if there was an issue in the combination of ext4,
> e2fsprogs 1.43.4 and Grub 2.02 in Debian Stretch (the latest Debian
> Stable, version 8.0) they would have found it.
>=20
> =85 snip

> So when you say that enabling the 64-bit file system feature causes a
> regression by causing Grub to fail to be able to read the root file
> system, I have to respectfully disagree.  I do it all the time when I
> reboot my kernel, and it Works For Me...
>=20
> 						- Ted

Huh ???  I indicated GRUB 2.00 stopped working with the upgrade to =
1.43.4, but GRUB 2.02 works fine.


Felipe=

--Apple-Mail=_42C088CE-DF7B-44D8-BED9-1C0543DB610D
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNzA2MjYwNjQ2NDlaMCMGCSqGSIb3DQEJBDEW
BBTx9AsQBa6kMFbOaH+9YH2e6G2cFTANBgkqhkiG9w0BAQEFAASBgN5rTCECKrAfmV8xkseKq3MG
ZSougu4a6q0gHSqm5WUUcsfDgVx149fPkT4LuW8BxHk9Kh/3WoeKZakSsqrSShf16PuxknTt37v7
af2RP1hdqSMqXlyIEFgQjetzQaY7p/VefRGijxxadMv7QcX6Q9l6hr5dJ4LOYSQmUeyGC4KeAAAA
AAAA

--Apple-Mail=_42C088CE-DF7B-44D8-BED9-1C0543DB610D--
