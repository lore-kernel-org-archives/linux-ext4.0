From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/5] ext4: add isolated project support
Date: Thu, 04 Mar 2010 23:34:43 +0300
Message-ID: <87sk8fbzbw.fsf@openvz.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-4-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-5-git-send-email-dmonakhov@openvz.org>
	<20100304200700.GA6092@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100304200700.GA6092@atrey.karlin.mff.cuni.cz> (Jan Kara's
	message of "Thu, 4 Mar 2010 21:07:00 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hi,
>
>> PROJECT_ISOLATION
>> This feature allows to create an isolated project subtrees.
>> Isolation means what:
>>   1) directory subtree has no common inodes (no hadlinks across subtrees)
>>   2) All descendants belongs to the same subtree.
>> 
>> Project subtree's isolation assumptions:
>>   1)Inode can not belongs to different subtree trees
>>     Otherwise changes in one subtree result in changes in other subtree
>>     which contradict to isolation criteria.
>   Just a curious question:
> Do you really need this subtree separation in your envisioned containers
> usecase? Because there I imagine you have one project_id per container,
> containers form disjoint subtrees (at least their writeable parts) and
> each file & directory has this project_id set and you forbid to manipulate
> project id's from inside the container (otherwise you'd have problems with
> enforcing quota limits I guess).
>
> And when project_id is a per-inode property, quota has no problems with it
> (is well defined) even without subtree separation. So is this subtree
> separation really needed?
You right containers dealt with with only one subtree so bindmount
is sufficient for all container's like sulutions.
I've done this isolation part after long discussion with Dave Chinner
He give some examples there fs-specific (not mount ones) isolation
is useful. Most obvious usage example of project which has several
trees. He intend that this feature is used by XFS users.
But this feature attract most complains from reviewers, and i'll drop
it if will be necessary to merge the project-id quota.
>
> 								Honza
