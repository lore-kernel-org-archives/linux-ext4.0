From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Random corruption test for e2fsck
Date: Tue, 10 Jul 2007 10:42:18 -0500
Message-ID: <4693A8DA.30606@redhat.com>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <20070710145855.GB27033@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbXGJPqJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 11:46:09 -0400
In-Reply-To: <20070710145855.GB27033@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
>> 5) If the test went by without any errors the test image is deleted and
>> in case of any errors the user is notified that the log of this test run
>> should be mailed to linux-ext4@ and the image should be preserved.
> 
> I certainly like the general concept!!
> 
> I wonder if the code to create a random filesystem and corrupting it
> should be kept as separate shell script, since it can be reused in
> another of interesting ways.  One thought would be to write a test
> script that mounts corrupted filesystems using UML and then does some
> exercises on it (tar cvf on the filesyste, random renames on the
> filesystem, rm -rf of all of the contents of the filesystems), to see
> whether we can provoke a kernel oops.

FWIW, that's what fsfuzzer does, in an fs-agnostic way.

-Eric
