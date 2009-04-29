From: "Ramesh" <ramesh@arasan.com>
Subject: File System Selection
Date: Wed, 29 Apr 2009 11:03:26 +0530 (IST)
Message-ID: <1240983206.446412847@192.168.1.35>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: ext3-users@redhat.com, linux-ext4@vger.kernel.org
Return-path: <ext3-users-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org


Hi All,


I am developing a SD Block Driver.

As per old specification (SD Spec 2.0 ) Maximum size of SD memory card is=
 32 GB.
- We used ext2 file system.

By referring the new Specification (SD Spec 3.0) SD memory card size is r=
eached upto and including 2TB (Terra Byte)
- Block size strictly limited to 512 only (as per specification).

My Questions.

1. For 2TB disk with Block size 512, Which file system is preferred (ext3=
/ext4)

2.
In a 32 bit machine, If I installed the Fedora 10 ( having ext4), am I
able to use it as effectively ( for the maximum disk/file size usage).
To utilize 2TB or more size hard disk, is this allowable to use 32 bit ma=
chine with Ext4 fs?


Thanks in advance.

Regards,
Ramesh



ATTENTION:

The information contained in this message may be legally privileged and c=
onfidential.  It is intended to be read only by the individual or entity =
to whom it is addressed or by their designee. If the reader of this messa=
ge is not the intended recipient, you are on notice that any distribution=
 of this message, in any form, is strictly prohibited by law.

If you have received this message in error, please immediately notify the=
 sender and/or Arasan Chip Systems, Inc. by telephone at (408) 282-1600 a=
nd delete or destroy any copy of this message.
