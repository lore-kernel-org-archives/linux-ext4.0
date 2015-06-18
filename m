From: Theodore Ts'o <tytso@mit.edu>
Subject: Test generic/299 stalling forever
Date: Thu, 18 Jun 2015 11:53:37 -0400
Message-ID: <20150618155337.GA10439@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've been trying to figure out why generic/299 has occasionally been
stalling forever.  After taking a closer look, it appears the problem
is that the fio process is stalling in userspace.  Looking at the ps
listing, the fio process hasn't run in over six hours, and using
attaching strace to the fio process, it's stalled in a FUTUEX_WAIT.

Has anyone else seen this?  I'm using fio 2.2.6, and I have a feeling
that I started seeing this when I started using a newer version of
fio.  So I'm going to try roll back to an older version of fio and see
if that causes the problem to go away.

		   	       	   	      	 - Ted
