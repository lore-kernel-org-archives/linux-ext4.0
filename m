From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Difference in jbd2 behavior between CentOS and Ubuntu while
 unmounting
Date: Wed, 18 May 2016 10:12:40 -0400
Message-ID: <20160518141240.GB1710@thunk.org>
References: <CAN0j2-ek1iJ_a8ii+sg+kTdjcmZD6jVUHO9SJBbbhfD+5s_CGw@mail.gmail.com>
 <32a9cbf4-4e2d-335c-0603-9639b30e2863@redhat.com>
 <CAN0j2-cp1odcT44ZoeFDGHMF519F2b9Ffa5vc8PJyJfSLcj5-Q@mail.gmail.com>
 <782fe069-c14f-4bae-609e-bbad554cb657@redhat.com>
 <20160518061834.GA4502@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Kamran Khan <krkhan@inspirated.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37972 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbcEROMu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2016 10:12:50 -0400
Content-Disposition: inline
In-Reply-To: <20160518061834.GA4502@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2016 at 11:18:34PM -0700, Darrick J. Wong wrote:
> Just to throw some gasoline on this fire, I hit the same set of symptoms
> a couple of weeks ago while trying to umount /home on 4.5.0 + Ubuntu 16.04.
> Ted mused that it could be some process running in a funny mount namespace.
> Or systemd dragons.  Or something.

Try the following to see if someone process is playing namespace games

find /proc -name mounts | xargs grep /dev/sda3

(replace /dev/sda3 with the device that you think is unmounted).

When you find the process, kill it.  (Or try doing a service XXX
restart assuming that the device has been unmounted in the "normal"
mount namespace.)

Another simple thing to try doing is to go into single user mode,
which will kill off all/most of your userspace processes, which may
also have the desired effect.  Much more of a blunt hammer, though.

     	      	      	       	    	 - Ted
