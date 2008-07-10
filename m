From: Theodore Tso <tytso@mit.edu>
Subject: [ricwheeler@gmail.com: suspiciously good fsck times?]
Date: Thu, 10 Jul 2008 13:28:29 -0400
Message-ID: <20080710172829.GF10402@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37952 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757689AbYGJR2b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 13:28:31 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Transferring this thread to the linux-ext4 list instead of
linux-ext4-owner.  :-)

						- Ted

--M9NhX3UHpAaciwkO
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <ricwheeler@gmail.com>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Thu, 10 Jul 2008 08:37:26 -0400
X-Sieve: CMU Sieve 2.2
Received: from pacific-carrier-annex.mit.edu by po14.mit.edu (8.13.6/4.7) id m6ACbQ6G014604; Thu, 10 Jul 2008 08:37:26 -0400 (EDT)
Received: from mit.edu (W92-130-BARRACUDA-3.MIT.EDU [18.7.21.224])
	by pacific-carrier-annex.mit.edu (8.13.6/8.9.2) with ESMTP id m6ACbE1f013342
	for <tytso@mit.edu>; Thu, 10 Jul 2008 08:37:14 -0400 (EDT)
Received: from hs-out-0708.google.com (hs-out-0708.google.com [64.233.178.246])
	by mit.edu (Spam Firewall) with ESMTP id 4E65D1016A46
	for <tytso@mit.edu>; Thu, 10 Jul 2008 08:37:01 -0400 (EDT)
Received: by hs-out-0708.google.com with SMTP id j58so787908hsj.6
        for <tytso@mit.edu>; Thu, 10 Jul 2008 05:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:message-id:date:from
         :user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding;
        bh=Q3vuSbDah+NFZQiXQmNHoHTk7GMCtqWA0jV/fjpoMmE=;
        b=eKICrRHCLrQYylvB+PinaxCIRON0cNg1rqeZ2mimMXpjo/DFG1FmCJWKo78uTIbmy6
         dNn49hW7nOHPrORQ6F6LbXb99fd/+GR9d9Fo/f1ZTK1qcmRIKC0x8Gt45/5yXiJLkVf2
         Pr3/wjsx6EvjgMe1eKMp8T457pAfAErbZXhew=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VXpOqF4nZ3UjzUNmAnhlloTqQc84ZcZWz5ENA8rwm3Uv4vhm7tR76/rpRXf9qBXzFP
         08wREnSoKz8/WLJy5a0yYQMC+w9KqJdOb+2P4RYrHUu0ctPyNamtOgJLfbv+uWoYf+6K
         /f/ZPG+cx9q7vzF23VQLQAOpKVRi0kl5sYwA0=
Received: by 10.100.140.12 with SMTP id n12mr7560808and.147.1215693421025;
        Thu, 10 Jul 2008 05:37:01 -0700 (PDT)
Received: from ?10.16.15.168? ( [66.187.234.199])
        by mx.google.com with ESMTPS id 4sm10169719yxd.2.2008.07.10.05.36.53
        (version=TLSv1/SSLv3 cipher=RC4-MD5);
        Thu, 10 Jul 2008 05:37:00 -0700 (PDT)
Message-ID: <4876025A.80909@gmail.com>
Date: Thu, 10 Jul 2008 08:36:42 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: linux-ext4-owner@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Subject: suspiciously good fsck times?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.00
X-Spam-Flag: NO
X-Scanned-By: MIMEDefang 2.42


Just to be mean, I have been trying to test the fsck speed of ext4 with 
lots of small files.  The test I ran uses fs_mark to fill a 1TB Seagate 
drive with 45.6 million 20k files (distributed between 256 subdirectories).

Running on ext3, "fsck -f" takes about one hour.

Running on ext4, with uninit_bg, the same fsck is finished in a bit over 
5 minutes - more than 10x faster.  (Without uninit_bg, the fsck takes 
about 10 minutes).

Is this too good to be true? Below is the fsck run itself, the tree is 
Ted's latest git tree and his 1.41 WIP tools,

ric


[root@localhost Perf]# time /sbin/fsck.ext4 -t -t -f /dev/sdb1
e4fsck 1.41-WIP (07-Jul-2008)
Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 40632k/69424k (36424k/4209k), time: 204.95/78.22/25.58
Pass 1: I/O read: 11140MB, write: 0MB, rate: 54.35MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 70184k/61968k (51803k/18382k), time: 76.47/50.27/ 8.77
Pass 2: I/O read: 3023MB, write: 0MB, rate: 39.53MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 70184k/61968k (59256k/10929k), time: 
281.72/128.59/34.35
Pass 3A: Memory used: 70184k/61968k (59256k/10929k), time:  0.00/ 0.00/ 
0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 70184k/61968k (51803k/18382k), time:  0.03/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 37.86MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 70184k/44968k (27354k/42831k), time:  2.37/ 2.36/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 70184k/240k (64619k/5566k), time: 19.40/ 5.52/ 0.29
Pass 5: I/O read: 34MB, write: 0MB, rate: 1.75MB/s
/dev/sdb1: 45600268/61054976 files (0.0% non-contiguous), 
232657574/244190000 blocks
Memory used: 70184k/240k (64889k/5296k), time: 303.54/136.48/34.65
I/O read: 14198MB, write: 1MB, rate: 46.77MB/s

real    5m3.993s
user    2m16.477s
sys     0m35.041s

--M9NhX3UHpAaciwkO
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <tytso@MIT.EDU>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Thu, 10 Jul 2008 11:18:44 -0400
X-Sieve: CMU Sieve 2.2
Received: from fort-point-station.mit.edu by po14.mit.edu (8.13.6/4.7) id m6AFIhZh009340; Thu, 10 Jul 2008 11:18:43 -0400 (EDT)
Received: from mit.edu (W92-130-BARRACUDA-1.MIT.EDU [18.7.21.220])
	by fort-point-station.mit.edu (8.13.6/8.9.2) with ESMTP id m6AFIZ11017277
	for <tytso@mit.edu>; Thu, 10 Jul 2008 11:18:36 -0400 (EDT)
Received: from thunker.thunk.org (www.church-of-our-saviour.ORG [69.25.196.31])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mit.edu (Spam Firewall) with ESMTP id 1C057A04085
	for <tytso@mit.edu>; Thu, 10 Jul 2008 11:18:25 -0400 (EDT)
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1KGxuZ-0004SF-9b; Thu, 10 Jul 2008 11:18:23 -0400
Received: from tytso by closure.thunk.org with local (Exim 4.69)
	(envelope-from <tytso@mit.edu>)
	id 1KGxuY-0002ZR-Na; Thu, 10 Jul 2008 11:18:22 -0400
Date: Thu, 10 Jul 2008 11:18:22 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: linux-ext4-owner@vger.kernel.org
Subject: Re: suspiciously good fsck times?
Message-ID: <20080710151822.GA25939@mit.edu>
References: <4876025A.80909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876025A.80909@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
X-Spam-Score: 0.00
X-Spam-Flag: NO
X-Scanned-By: MIMEDefang 2.42

On Thu, Jul 10, 2008 at 08:36:42AM -0400, Ric Wheeler wrote:
>
> Just to be mean, I have been trying to test the fsck speed of ext4 with  
> lots of small files.  The test I ran uses fs_mark to fill a 1TB Seagate  
> drive with 45.6 million 20k files (distributed between 256 
> subdirectories).
>
> Running on ext3, "fsck -f" takes about one hour.
>
> Running on ext4, with uninit_bg, the same fsck is finished in a bit over  
> 5 minutes - more than 10x faster.  (Without uninit_bg, the fsck takes  
> about 10 minutes).
>
> Is this too good to be true? Below is the fsck run itself, the tree is  
> Ted's latest git tree and his 1.41 WIP tools,

Wow.  My guess is that flex_bg is making the difference.  What we
would want to compare is the I/O read statistics line:

> I/O read: 14198MB, write: 1MB, rate: 46.77MB/s

That's pretty good, and indicates we've avoided a *lot* of seeking.
The e2fsck -t -t output for ext3 should show roughly the same mount of
I/O read (with 20k files, there would be no advantage towards using
extents), but the I/O rate is probably *much* lower, indicating a lot
more seeking is going on.

Can you send the full e2fsck -t -t output of the ext3 run?  And what
is the hdparm -t -t results of the disk?

If I'm right, if you create the filesystem with mke2fs -t ext4dev -O
^flex_bg,^uninit_bg, you should see performance back to the old ext3
levels.

							- Ted

P.S.  We probably do want to examine the block allocation layout with
flex_bg to make sure that the filesystem ages well in the long term.

--M9NhX3UHpAaciwkO
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <rwheeler@redhat.com>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Thu, 10 Jul 2008 11:50:06 -0400
X-Sieve: CMU Sieve 2.2
Received: from pacific-carrier-annex.mit.edu by po14.mit.edu (8.13.6/4.7) id m6AFo57n006429; Thu, 10 Jul 2008 11:50:05 -0400 (EDT)
Received: from mit.edu (M24-004-BARRACUDA-1.MIT.EDU [18.7.7.111])
	by pacific-carrier-annex.mit.edu (8.13.6/8.9.2) with ESMTP id m6AFnrnS028296
	for <tytso@mit.edu>; Thu, 10 Jul 2008 11:49:53 -0400 (EDT)
X-ASG-Whitelist: Barracuda Reputation
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by mit.edu (Spam Firewall) with ESMTP id 1ED78A055A3
	for <tytso@mit.edu>; Thu, 10 Jul 2008 11:49:53 -0400 (EDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6AFnqG5019173;
	Thu, 10 Jul 2008 11:49:52 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AFnpQA023470;
	Thu, 10 Jul 2008 11:49:51 -0400
Received: from [10.16.10.117] (vpn-10-117.bos.redhat.com [10.16.10.117])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m6AFnpaI025621;
	Thu, 10 Jul 2008 11:49:51 -0400
Message-ID: <48762F9F.5070308@redhat.com>
Date: Thu, 10 Jul 2008 11:49:51 -0400
From: Ric Wheeler <rwheeler@redhat.com>
Reply-To: rwheeler@redhat.com
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: linux-ext4-owner@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: suspiciously good fsck times?
References: <4876025A.80909@gmail.com> <20080710151822.GA25939@mit.edu>
In-Reply-To: <20080710151822.GA25939@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.42
X-Scanned-By: MIMEDefang 2.58 on 172.16.52.254
X-Spam-Score: 0
X-Spam-Flag: NO

Theodore Tso wrote:
> On Thu, Jul 10, 2008 at 08:36:42AM -0400, Ric Wheeler wrote:
>   
>> Just to be mean, I have been trying to test the fsck speed of ext4 with  
>> lots of small files.  The test I ran uses fs_mark to fill a 1TB Seagate  
>> drive with 45.6 million 20k files (distributed between 256 
>> subdirectories).
>>
>> Running on ext3, "fsck -f" takes about one hour.
>>
>> Running on ext4, with uninit_bg, the same fsck is finished in a bit over  
>> 5 minutes - more than 10x faster.  (Without uninit_bg, the fsck takes  
>> about 10 minutes).
>>
>> Is this too good to be true? Below is the fsck run itself, the tree is  
>> Ted's latest git tree and his 1.41 WIP tools,
>>     
>
> Wow.  My guess is that flex_bg is making the difference.  What we
> would want to compare is the I/O read statistics line:
>
>   
>> I/O read: 14198MB, write: 1MB, rate: 46.77MB/s
>>     
>
> That's pretty good, and indicates we've avoided a *lot* of seeking.
> The e2fsck -t -t output for ext3 should show roughly the same mount of
> I/O read (with 20k files, there would be no advantage towards using
> extents), but the I/O rate is probably *much* lower, indicating a lot
> more seeking is going on.
>   
We did run fsck through seekwatcher & saw a significant reduction in 
seeks/sec for ext4. Eric has the pretty pictures that he can share.

> Can you send the full e2fsck -t -t output of the ext3 run?  And what
> is the hdparm -t -t results of the disk?
>   

I didn't run the ext3 test with -t -t (but can refill and rerun, takes 
about 12 hours).

This disk is a relatively new Seagate 1TB drive, specs at:

http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD

hdparm test:

[root@localhost rwheeler]# /sbin/hdparm -t -t /dev/sdb

/dev/sdb:
 Timing buffered disk reads:  186 MB in  3.03 seconds =  61.33 MB/sec



> If I'm right, if you create the filesystem with mke2fs -t ext4dev -O
> ^flex_bg,^uninit_bg, you should see performance back to the old ext3
> levels.
>   

With uninit_bg off, it ran about 10 minutes, but it would be interesting 
to run without either.
> 							- Ted
>
> P.S.  We probably do want to examine the block allocation layout with
> flex_bg to make sure that the filesystem ages well in the long term.
>   
Testing aged file systems is always the holy grail - this workload is a 
fairly artificial one and was laid down with 4 threads currently writing 
to a shared subdirectory.

ric


--M9NhX3UHpAaciwkO
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <tytso@MIT.EDU>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Thu, 10 Jul 2008 12:14:26 -0400
X-Sieve: CMU Sieve 2.2
Received: from fort-point-station.mit.edu by po14.mit.edu (8.13.6/4.7) id m6AGEQkV027409; Thu, 10 Jul 2008 12:14:26 -0400 (EDT)
Received: from mit.edu (M24-004-BARRACUDA-2.MIT.EDU [18.7.7.112])
	by fort-point-station.mit.edu (8.13.6/8.9.2) with ESMTP id m6AGEGlg009631
	for <tytso@mit.edu>; Thu, 10 Jul 2008 12:14:17 -0400 (EDT)
Received: from thunker.thunk.org (www.church-of-our-saviour.org [69.25.196.31])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mit.edu (Spam Firewall) with ESMTP id 64A6511BB75E
	for <tytso@mit.edu>; Thu, 10 Jul 2008 12:14:02 -0400 (EDT)
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1KGymJ-0004a1-VA; Thu, 10 Jul 2008 12:13:56 -0400
Received: from tytso by closure.thunk.org with local (Exim 4.69)
	(envelope-from <tytso@mit.edu>)
	id 1KGymI-0003mB-UC; Thu, 10 Jul 2008 12:13:54 -0400
Date: Thu, 10 Jul 2008 12:13:54 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-ext4-owner@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: suspiciously good fsck times?
Message-ID: <20080710161354.GA10402@mit.edu>
References: <4876025A.80909@gmail.com> <20080710151822.GA25939@mit.edu> <48762F9F.5070308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48762F9F.5070308@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
X-Spam-Score: 0.00
X-Spam-Flag: NO
X-Scanned-By: MIMEDefang 2.42

On Thu, Jul 10, 2008 at 11:49:51AM -0400, Ric Wheeler wrote:
> We did run fsck through seekwatcher & saw a significant reduction in  
> seeks/sec for ext4. Eric has the pretty pictures that he can share.

Pictures are always fun!  It would be great to see the comparison
between ext3 and ext4 for fsck in this case.

> [root@localhost rwheeler]# /sbin/hdparm -t -t /dev/sdb
>
> /dev/sdb:
> Timing buffered disk reads:  186 MB in  3.03 seconds =  61.33 MB/sec
>

I meant hdparm -t -T, but that's ok, the 61.33 MB/sec is what I was
curious about.  So for this very artificial benchmark, fsck was using
2/3rd of the disk's full benchmark.  Not bad.  :-)

> Testing aged file systems is always the holy grail - this workload is a  
> fairly artificial one and was laid down with 4 threads currently writing  
> to a shared subdirectory.

If you haven't nuked the ext4 filesystem yet, can you grab a dumpe2fs
of it first, so we can compare it to the inode allocation patterns
under ext3.  Thanks!!

						- Ted

--M9NhX3UHpAaciwkO
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <sandeen@redhat.com>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Thu, 10 Jul 2008 12:37:30 -0400
X-Sieve: CMU Sieve 2.2
Received: from pacific-carrier-annex.mit.edu by po14.mit.edu (8.13.6/4.7) id m6AGbTgx015684; Thu, 10 Jul 2008 12:37:29 -0400 (EDT)
Received: from mit.edu (W92-130-BARRACUDA-1.MIT.EDU [18.7.21.220])
	by pacific-carrier-annex.mit.edu (8.13.6/8.9.2) with ESMTP id m6AGbJFS008456
	for <tytso@mit.edu>; Thu, 10 Jul 2008 12:37:19 -0400 (EDT)
X-ASG-Whitelist: Barracuda Reputation
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by mit.edu (Spam Firewall) with ESMTP id 2FD13A12783
	for <tytso@mit.edu>; Thu, 10 Jul 2008 12:37:19 -0400 (EDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6AGbIaI006717;
	Thu, 10 Jul 2008 12:37:18 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AGEdmB014184;
	Thu, 10 Jul 2008 12:14:39 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AGEa7N024663;
	Thu, 10 Jul 2008 12:14:37 -0400
Message-ID: <48763564.2090505@redhat.com>
Date: Thu, 10 Jul 2008 11:14:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: rwheeler@redhat.com
CC: Theodore Tso <tytso@mit.edu>, linux-ext4-owner@vger.kernel.org
Subject: Re: suspiciously good fsck times?
References: <4876025A.80909@gmail.com> <20080710151822.GA25939@mit.edu> <48762F9F.5070308@redhat.com>
In-Reply-To: <48762F9F.5070308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.42
X-Scanned-By: MIMEDefang 2.58 on 172.16.52.254
X-Spam-Score: -2.464
X-Spam-Flag: NO

Ric Wheeler wrote:
> Theodore Tso wrote:
>> On Thu, Jul 10, 2008 at 08:36:42AM -0400, Ric Wheeler wrote:
>>   
>>> Just to be mean, I have been trying to test the fsck speed of ext4 with  
>>> lots of small files.  The test I ran uses fs_mark to fill a 1TB Seagate  
>>> drive with 45.6 million 20k files (distributed between 256 
>>> subdirectories).
>>>
>>> Running on ext3, "fsck -f" takes about one hour.
>>>
>>> Running on ext4, with uninit_bg, the same fsck is finished in a bit over  
>>> 5 minutes - more than 10x faster.  (Without uninit_bg, the fsck takes  
>>> about 10 minutes).
>>>
>>> Is this too good to be true? Below is the fsck run itself, the tree is  
>>> Ted's latest git tree and his 1.41 WIP tools,
>>>     
>> Wow.  My guess is that flex_bg is making the difference.  What we
>> would want to compare is the I/O read statistics line:

I thought we actually had flex_bg off at least on the first run and it
still looked good.  (Ric just made the fs with mkfs.ext3 -j -I 256 -E
test_fs initially I think)

Val & I talked about this a little, and came to the conclusion that
directory fragmentation might be a pretty big part of it.

I did a similar workload on a much smaller fs, and the largest dir
(~11MB) looked like this on ext3:

BLOCKS:
(0-4):3950592-3950596, (5):3950604, (6-7):3950606-3950607, (8):3950630,
(9):3950871, (10-11):3950875-3950876, (IND):3950899, (12):3950900,
(13):3950934, (14):3950937, (15-16):3950943-3950944, (17):3951390,
(18):3951396, (19):3951402, (20):3951406, (21):3951408, (22):3951410,
(23):3951581, (24):3951684, (25):3951985, (26):3952031, (27):3952156,
(28):3952322, (29):3952418, (30):3952599, (31):3952626, (32):3954038,
(33):3954693, (34):3954698, (35):3954874, (36):3955108, (37):3955708,
(38):3955711, (39):3956034, (40):3956598, (41):3957173, (42):3957179,
(43):3957622, (44):3957763, (45):3957824, (46):3957910, (47):3958190,
(48):3958302, (49):3958488, (50):3958834, (51):3959173, (52):3959468,
(53):3959842, (54):3959903, (55):3960029, (56):3960245, (57):3960446
..... ad naseum ...
(4032):4893557, (4033):4894194, (4034):4894719, (4035):4937580,
(4036):4937887, (4037):4939087, (4038):4939233, (4039):4939502,
(4040):4939508, (4041):4940473, (4042-4043):4940939-4940940,
(4044):4941191, (4045):4941402, (4046-4048):4941409-4941411,
(4049):4943061, (4050):4943307, (4051-4052):4943314-4943315
TOTAL: 4058

compared to ext4:

BLOCKS:
(0):1900544, (1-5070):1900546-1905615
TOTAL: 5071


> We did run fsck through seekwatcher & saw a significant reduction in 
> seeks/sec for ext4. Eric has the pretty pictures that he can share.

sure do (AFAIK these were with neither flex_bg nor uninit_bg):

http://people.redhat.com/esandeen/ext4/e4fsck-1T.png
http://people.redhat.com/esandeen/ext4/e3fsck-1T.png
http://people.redhat.com/esandeen/ext4/ext3-ext4-fsck-1T.png

I'm still working out what's what.  But that hockey-stick-shaped red
line for ext4 is intriguing, I think it's very densely packed $SOMETHING
that ext3 had to seek all over for, guessing it's the directories.
Although that strikes me as an odd place for the root-level directories
to land.

I need to check, does ext3 use reservation windows for directories?
Looks like maybe it should... :)

-Eric



--M9NhX3UHpAaciwkO
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <tytso@MIT.EDU>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Thu, 10 Jul 2008 13:21:50 -0400
X-Sieve: CMU Sieve 2.2
Received: from fort-point-station.mit.edu by po14.mit.edu (8.13.6/4.7) id m6AHLn7K021973; Thu, 10 Jul 2008 13:21:50 -0400 (EDT)
Received: from mit.edu (W92-130-BARRACUDA-1.MIT.EDU [18.7.21.220])
	by fort-point-station.mit.edu (8.13.6/8.9.2) with ESMTP id m6AHLdov014517
	for <tytso@mit.edu>; Thu, 10 Jul 2008 13:21:39 -0400 (EDT)
Received: from thunker.thunk.org (www.church-of-our-saviour.ORG [69.25.196.31])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mit.edu (Spam Firewall) with ESMTP id 7D1A4A12FF4
	for <tytso@mit.edu>; Thu, 10 Jul 2008 13:21:27 -0400 (EDT)
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1KGzpV-0004mu-Vu; Thu, 10 Jul 2008 13:21:18 -0400
Received: from tytso by closure.thunk.org with local (Exim 4.69)
	(envelope-from <tytso@mit.edu>)
	id 1KGzpV-0000r0-D6; Thu, 10 Jul 2008 13:21:17 -0400
Date: Thu, 10 Jul 2008 13:21:17 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Eric Sandeen <sandeen@redhat.com>
Cc: rwheeler@redhat.com, linux-ext4-owner@vger.kernel.org
Subject: Re: suspiciously good fsck times?
Message-ID: <20080710172117.GE10402@mit.edu>
References: <4876025A.80909@gmail.com> <20080710151822.GA25939@mit.edu> <48762F9F.5070308@redhat.com> <48763564.2090505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48763564.2090505@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
X-Spam-Score: 0.00
X-Spam-Flag: NO
X-Scanned-By: MIMEDefang 2.42

On Thu, Jul 10, 2008 at 11:14:28AM -0500, Eric Sandeen wrote:
> Val & I talked about this a little, and came to the conclusion that
> directory fragmentation might be a pretty big part of it.

Hmm, could be.  Let's see.  Ric said 46.5 million files, I don't know
how big the filenames were, but let's assume a directory entry size of
32, so that means if we assume perfect packing, 128 directory entries
per 4k block.  Let's use 100 directory entries/blok just to make the
math easyer, so that's 465,000 blocks.  If we assume a 10ms seek time,
and that the blocks are totally scattered, that's 4650 seconds, or
1.29 hours. So that's roughly within the ballpark that Ric measured.

     	       	      	      	     	 	  - Ted

--M9NhX3UHpAaciwkO
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <sandeen@redhat.com>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Thu, 10 Jul 2008 13:23:25 -0400
X-Sieve: CMU Sieve 2.2
Received: from pacific-carrier-annex.mit.edu by po14.mit.edu (8.13.6/4.7) id m6AHNOwb023297; Thu, 10 Jul 2008 13:23:25 -0400 (EDT)
Received: from mit.edu (W92-130-BARRACUDA-1.MIT.EDU [18.7.21.220])
	by pacific-carrier-annex.mit.edu (8.13.6/8.9.2) with ESMTP id m6AHNDMx016641
	for <tytso@mit.edu>; Thu, 10 Jul 2008 13:23:14 -0400 (EDT)
X-ASG-Whitelist: Barracuda Reputation
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by mit.edu (Spam Firewall) with ESMTP id B8306A1A1FF
	for <tytso@mit.edu>; Thu, 10 Jul 2008 13:23:13 -0400 (EDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6AHNDMR025933;
	Thu, 10 Jul 2008 13:23:13 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AHNClp006616;
	Thu, 10 Jul 2008 13:23:12 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AHN9Sb011302;
	Thu, 10 Jul 2008 13:23:11 -0400
Message-ID: <4876457C.3040709@redhat.com>
Date: Thu, 10 Jul 2008 12:23:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: rwheeler@redhat.com, linux-ext4-owner@vger.kernel.org
Subject: Re: suspiciously good fsck times?
References: <4876025A.80909@gmail.com> <20080710151822.GA25939@mit.edu> <48762F9F.5070308@redhat.com> <48763564.2090505@redhat.com> <20080710172117.GE10402@mit.edu>
In-Reply-To: <20080710172117.GE10402@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.42
X-Scanned-By: MIMEDefang 2.58 on 172.16.52.254
X-Spam-Score: -2.464
X-Spam-Flag: NO

Theodore Tso wrote:
> On Thu, Jul 10, 2008 at 11:14:28AM -0500, Eric Sandeen wrote:
>> Val & I talked about this a little, and came to the conclusion that
>> directory fragmentation might be a pretty big part of it.
> 
> Hmm, could be.  Let's see.  Ric said 46.5 million files, I don't know
> how big the filenames were, but let's assume a directory entry size of
> 32, so that means if we assume perfect packing, 128 directory entries
> per 4k block.  Let's use 100 directory entries/blok just to make the
> math easyer, so that's 465,000 blocks.  If we assume a 10ms seek time,
> and that the blocks are totally scattered, that's 4650 seconds, or
> 1.29 hours. So that's roughly within the ballpark that Ric measured.
> 
>      	       	      	      	     	 	  - Ted


btw guys  this thread is not on linux-ext4, it's going to linux-ext4-owner

maybe someone who has them all can bounce to the list ;)

-Eric

--M9NhX3UHpAaciwkO--
