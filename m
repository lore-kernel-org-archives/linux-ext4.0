From: Jun He <jhe@cs.wisc.edu>
Subject: e2fsprogs: debugfs: set_inode_field fails to set block[IND]...
Date: Mon, 18 Aug 2014 23:32:10 -0500
Message-ID: <CABW1wHSXSc-4kNDEzGKxPYTfust0Htc66VkcmoJVxrS-FA9Oog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:47220 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaHSEcv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2014 00:32:51 -0400
Received: by mail-oi0-f52.google.com with SMTP id h136so4260756oig.11
        for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2014 21:32:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I hope this is the right place to report problems of e2fsprogs.

When trying to update block[IND], block[DIND], and block[TIND], it
gives the similar error message:

jhe@node001:~$ sudo debugfs /dev/loop0 -w -R 'set_inode_field
firstfile block[IND] 2'
debugfs 1.42 (29-Nov-2011)
set_inode_field: invalid field specifier: block[IND]

I looked at the code and found the problem in the following code in
find_field() in debugfs/set_fields.c.

    idx = strchr(arg, '[');
    if (idx) {
        *idx++ = 0;
        delim = idx + strlen(idx) - 1;
        if (!*idx || *delim != ']')
            idx = 0;
        else
            *delim = 0;
    }
    /*
     * Can we parse the number?
     */
    if (idx) {
        array_idx = strtol(idx, &tmp, 0);
        if (*tmp)
            idx = 0;
    }


When the field name is something like "block[4]", this works. It sets
'[' and ']' to 0 and converts the number between them.
When the field name is block[IND], it still replaces '[' and ']' with
0. So arg becomes 'block' and will always fail the following test of
  if (strcmp(ss->name, arg) != 0).

One possible fix is to change the max limit for field 'block', use
number to index IND, DIND, and TIND.
Or, name 'block[IND]', 'block[DIND]', and 'block[TIND]' differently
without the '[' ']'. Such as 'block.IND', 'block.DIND', 'block.TIND'.

If it's just a usage problem, please let me know how to use
set_inode_field to set block[IND].. correctly.

Thanks,
Jun
