From: Felipe A Rodriguez <far@illumenos.com>
Subject: Possible regression in e2fsprogs-1.43.4
Date: Sat, 10 Jun 2017 16:00:20 +0200
Message-ID: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_13492744-C856-4DD7-B57C-8D1431142C86"; protocol="application/pkcs7-signature"; micalg=sha1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.illumenos.com ([46.101.240.157]:58127 "EHLO
        mail.illumenos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdFJOIE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Jun 2017 10:08:04 -0400
Received: from [192.168.1.33] (217-162-97-158.dynamic.hispeed.ch [217.162.97.158]);
        by mail.illumenos.com (OpenSMTPD) with ESMTPSA id 3ebc51ca;
        TLS version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO;
        for <linux-ext4@vger.kernel.org>;
        Sat, 10 Jun 2017 14:01:22 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_13492744-C856-4DD7-B57C-8D1431142C86
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes the boot =
loader to fail (unknown filesystem error) on the x86_64 VM I use for =
initial testing.  I traced the problem to changes in the e2fsprogs =
configuration file which now sets 64 bit flags.  I tried upgrading to =
GRUB 2.02 but that did not resolve the problem.  Reverting the changes =
per the patch below fixes the problem. =20


Kernel: 3.16.42, x86_64
Bootloader:  GRUB 2.00
Filesystem:  Ext4



diff -ruN e2fsprogs-1.43.4/misc/mke2fs.conf.in =
e2fsprogs-1.43.4-patched/misc/mke2fs.conf.in
--- e2fsprogs-1.43.4/misc/mke2fs.conf.in	Wed Feb  1 01:56:32 2017
+++ e2fsprogs-1.43.4-patched/misc/mke2fs.conf.in	Sat Jun  3 =
23:21:39 2017
@@ -11,11 +11,12 @@
 		features =3D has_journal
 	}
 	ext4 =3D {
-		features =3D =
has_journal,extent,huge_file,flex_bg,uninit_bg,64bit,dir_nlink,extra_isize=

+		features =3D =
has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
+		auto_64-bit_support =3D 1
 		inode_size =3D 256
 	}
 	ext4dev =3D {
-		features =3D =
has_journal,extent,huge_file,flex_bg,uninit_bg,inline_data,64bit,dir_nlink=
,extra_isize
+		features =3D =
has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
 		inode_size =3D 256
 		options =3D test_fs=3D1
 	}



Regards,

Felipe A. Rodriguez


illumenos LLC
________________________






--Apple-Mail=_13492744-C856-4DD7-B57C-8D1431142C86
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNzA2MTAxNDAwMjFaMCMGCSqGSIb3DQEJBDEW
BBQMY//jWyDUes+uHXrXaLbMyjVR7jANBgkqhkiG9w0BAQEFAASBgNko73WtKErYiz5MTUnIwi2h
6QfydLPJBC2BEyERevXOVI9vsfgmZRE8CP6b2cDYIK8Fs8NtpJUztCrjHtoGfYLQik2lPGdlSXoc
zWUqefbXGsip1Cr719C2hZe9yCx2Ywpp9RFJjSkCoMIt8drH5Vs3OK3XnPUSirt0jj7R98cuAAAA
AAAA

--Apple-Mail=_13492744-C856-4DD7-B57C-8D1431142C86--
