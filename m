From: Raymond Jennings <shentino@gmail.com>
Subject: Question about dirty data for unlinked files
Date: Thu, 23 Mar 2017 13:07:23 -0700
Message-ID: <CAGDaZ_qFMGuNMGzvOyStmtC9ZcCH3knHrhaOiP8HvmaphcWvVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:36019 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdCWUIK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Mar 2017 16:08:10 -0400
Received: by mail-qt0-f173.google.com with SMTP id r45so185267277qte.3
        for <linux-ext4@vger.kernel.org>; Thu, 23 Mar 2017 13:08:09 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If you delete a file (and don't have it open), and there's a bunch of
dirty data for that file still in page cache, does all that dirty data
disappear or does it still get written back?

I'm curious for performance reasons because I have an experimental
process I'm developing, and it has a habit of leaving large amounts of
dirty data in a huge output file.  I'd like to be able to unlink the
file and skip the writeback process once the file's been unlinked.
