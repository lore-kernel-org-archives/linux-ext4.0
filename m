From: Graham Murray <graham@gmurray.org.uk>
Subject: Zero length files - an alternative approach?
Date: Sun, 29 Mar 2009 11:43:59 +0100
Message-ID: <87bprka9sg.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754622AbZC2KoU@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just a thought on the ongoing discussion of dataloss with ext4 vs ext3.

Taking the common scenario:
Read oldfile
create newfile file
write newfile data
close newfile
rename newfile to oldfile

When using this scenario, the application writer wants to ensure that
either the old or new content are present. With delayed allocation, this
can lead to zero length files. Most of the suggestions on how to address
this have involved syncing the data either before the rename or making
the rename sync the data.

What about, instead of 'bringing forward' the allocation and flushing of
the data, would it be possible to instead delay the rename until after
the blocks for newfile have been allocated and the data buffers flushed?
This would keep the performance benefits of delayed allocation etc and
also satisfy the applications developers' apparent dislike of using
fsync(). It would give better performance that syncing the data at
rename time (either using fsync() or automatically) and satisfy the
requirements that either the old or new content is present.

I am not a filesystem developer, so do not know how feasible this would
be. 
