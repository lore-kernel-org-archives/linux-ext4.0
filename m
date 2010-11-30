From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Tue, 30 Nov 2010 18:07:09 GMT
Message-ID: <201011301807.oAUI7945007332@demeter1.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:60776 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab0K3SHN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Nov 2010 13:07:13 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAUI7CJd007370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Nov 2010 18:07:12 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772





--- Comment #17 from Eric Sandeen <sandeen@redhat.com>  2010-11-30 18:07:08 ---
Something is scribbling on / has scribbled on the front of your filesystem, it
seems.

hexdumping the first 2 blocks you sent:

00000580  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
000005e0  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff 0f 00  |................|
000005f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000600  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00000660  ff ff ff ff ff ff ff 01  00 00 00 00 00 00 00 00  |................|
00000670  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000680  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
000006e0  ff ff ff ff ff ff ff ff  0f 00 00 00 00 00 00 00  |................|
00000580  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
000005e0  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff 0f 00  |................|
000005f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000600  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00000660  ff ff ff ff ff ff ff 01  00 00 00 00 00 00 00 00  |................|
00000670  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000680  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
000006e0  ff ff ff ff ff ff ff ff  0f 00 00 00 00 00 00 00  |................|
000006f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000700  ff ff ff ff 7f 00 00 00  00 00 00 00 00 00 00 00  |................|
00000710  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|


superblock starts at 0x400; so here we are at offset 0x180 to 0x310 in the sb.

There's a lot of "-1" (0xff) in there with a few other values.  This translates
into the "4294967295" values you see above.

The various error tracking bits are in this part of the superblock so you're
seeing the -1/4294967295 pop out in the error reporting code:

     __le32    s_error_count;        /* number of fs errors */
     __le32    s_first_error_time;    /* first time an error happened */
     __le32    s_first_error_ino;    /* inode involved in first error */
/*1a0*/    __le64    s_first_error_block;    /* block involved of first error
*/
/*1a8*/    __u8    s_first_error_func[32];    /* function where the error
happened */
/*1c8*/    __le32    s_first_error_line;    /* line number where error happened
*/
     __le32    s_last_error_time;    /* most recent time of an error */
/*1d0*/    __le32    s_last_error_ino;    /* inode involved in last error */
     __le32    s_last_error_line;    /* line number where error happened */
     __le64    s_last_error_block;    /* block involved of last error */
/*1e0*/    __u8    s_last_error_func[32];    /* function where the error
happened */

Your dd above should have zeroed this out, though, which makes me wonder how
you got 1's back in here.  It could be anything, though I wonder if it's
possible that it's a stray bitmap....

What kind of storage is this?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
