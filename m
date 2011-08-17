From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: debugfs: list inode numbers?
Date: Wed, 17 Aug 2011 12:21:22 +0700
Message-ID: <86ippw1ulp.fsf_-_@gray.siamics.net>
References: <86ei0p8ve2.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151125470.3695@dhcp-27-109.brq.redhat.com>
	<86zkjb3p7f.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151759040.3695@dhcp-27-109.brq.redhat.com>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55478 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab1HQFVh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 01:21:37 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QtYZL-0004AB-GY
	for linux-ext4@vger.kernel.org; Wed, 17 Aug 2011 07:21:35 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 07:21:35 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 07:21:35 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Lukas Czerner <lczerner@redhat.com> writes:
>>>>> On Mon, 15 Aug 2011, Ivan Shmakov wrote:
>>>>> Lukas Czerner <lczerner@redhat.com> writes:

[=E2=80=A6]

 >>> and with a little bit of scripting around it you should be able di=
g
 >>> any information you desire from the file system so I do not think
 >>> that new application is needed.  But I might be wrong, just take a
 >>> look at it.

 >> Indeed, my first try was to use debugfs(8).  However, there're
 >> several issues with it:

 >> =E2=80=A2 I see no way to obtain the list of used inodes in debugfs=
(8)
 >> (as of 1.41.12 debian 2); therefore, I have had to resort to
 >> trying the =E2=80=98stat=E2=80=99 command on every possible inode n=
umber;

 > I am not sure if there is a way to list used inodes in debugfs but i=
t
 > should be very easy to implement.

	Something along the lines of the following, perhaps (assuming
	ISO C99):

   {
     int only_with_blocks_p
       =3D 0;
     ext2_inode_scan scan;

     {
       errcode_t r
         =3D ext2fs_open_inode_scan (e2, 0, &scan);
       assert (r =3D=3D 0);
     }

     FILE *out
       =3D stdout;
     errcode_t r;
     ext2_ino_t ino;
     struct ext2_inode inode;
     int column;

     /* FIXME: handle EXT2_ET_BAD_BLOCK_IN_INODE_TABLE, too */
     while (((r =3D ext2fs_get_next_inode (scan, &ino, &inode)) =3D=3D =
0)
            && ino !=3D 0) {
       if (! only_with_blocks_p
           || ext2fs_inode_has_valid_blocks (inode)) {
         /* skip over the inodes lacking valid blocks, if requested */
	 continue;
       }

       int n
         =3D fprintf (out, " <%d>");
       assert (n >=3D 0);
       column +=3D n;
       /* NB: assuming that a typical inode number will be less than 9
              decimal digits long, and that the terminal has 80 columns
              */
       if (column >=3D 80 - 12) {
         fputc ('\n', out);
       }
     }
     /* FIXME: handle EXT2_ET_BAD_BLOCK_IN_INODE_TABLE, too */
     assert (r =3D=3D 0);
   }

	Or should I develop a proper patch?

[=E2=80=A6]

--=20
=46SF associate member #7257

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
