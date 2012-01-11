From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Tue, 10 Jan 2012 21:08:27 -0600
Message-ID: <4F0CFD2B.7010404@redhat.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com> <1323367477-21685-2-git-send-email-kamal@canonical.com> <4F0C9D87.8010006@sandeen.net> <20120110213104.GI4516@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Kamal Mostafa <kamal@canonical.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab2AKDJD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 22:09:03 -0500
In-Reply-To: <20120110213104.GI4516@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/10/12 3:31 PM, Jan Kara wrote:
> On Tue 10-01-12 14:20:23, Eric Sandeen wrote:

<snip>

>> Hrm let me think through this a little more; we actually do:
>>
>> t16) ext4_journal_start()
>>   t17) ext4_journal_start_sb()
>>     t18) handle = ext4_journal_current_handle();
>>     t19) if (!handle) vfs_check_frozen()
>>     t20) ... jbd2_journal_start()
>   Ah, right. I forgot.
> 
>> So actually we *do* block new handles, but let *existing* ones
>> continue (see commits 6b0310fbf087ad6e9e3b8392adca97cd77184084
>> and be4f27d324e8ddd57cc0d4d604fe85ee0425cba9)
>>
>> So your assertion that a new handle is started is incorrect
>> in general, isn't it?  So then does the fix seem necessary?
>> Or, at least, in the fashion below - maybe we need to just make
>> sure all started handles complete before the unlock_updates?
>> Or am I missing something...?
>   Well, the problem with running operations and freezing is more
> fundamental I believe. See my email
> http://marc.info/?l=linux-fsdevel&m=132585911925796&w=2
> 
> So I believe we'll need some better exclusion mechanism already in VFS.
> 
> 								Honza
> 

Yep, saw it, just wasn't sure if this patchset was still under active consideration.

Thanks,
-Eric

