From: James Courtier-Dutton <james.dutton@gmail.com>
Subject: API for Vectorising IO
Date: Sat, 22 Apr 2017 11:39:08 +0100
Message-ID: <CAAMvbhFmbLtMizB3KBPhUnvhN3iFeJkg06=O7utwyTtFxLDd6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:33665 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1043801AbdDVKju (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Apr 2017 06:39:50 -0400
Received: by mail-yb0-f171.google.com with SMTP id 81so51553607ybp.0
        for <linux-ext4@vger.kernel.org>; Sat, 22 Apr 2017 03:39:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I recently read this, which talks about vectorised IO for NFS.
https://www.fsl.cs.sunysb.edu/docs/nfs4perf/vnfs-fast17.pdf

Are there any ways to do this for ext4?
For example:
A single syscall() that would list all the files in a directory.
I.e. A sort of list_all_files() all as a single syscall().
Also, having the API as async and partial results:
I.e. send list_all_files() message.
receive a request_id.
send get_next_1000_files(request_id)
receive the next 1000 files in that directory.

So, a sort of partial results,but with batching, in this case batch
1000 files at a time.

similarly for a read_all_files(list_of_files).
would then send back all the file's contents.

Surely, if the file system knows the full picture, earlier, it can
better optimise the results.
So, this lets the application request a list of many different file
operations ahead of time. gets a "request_id" back. And can then
gather the results later.

The important point here, is finding ways to limit the round-trip time
and amount of requests/responses.
The returning of a "request_id" means that the request is returned
without even needing to access the disk, thereby limiting round-trip
time to a minimum.

A similar approach could be used to optimise file find operations, but
I suspect this sort of operation is still better optimised with an
index in user space. E.g. Apache Lucene.

While vectorised IO work improve file access over the network
considerably, if local file systems also used the same API,
applications could be written, using a single API, and work
efficiently on both local and remote filesystems.

Kind Regards

James
