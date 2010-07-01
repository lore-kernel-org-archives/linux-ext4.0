From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 22:57:07 -0600
Message-ID: <84225B35-7365-4DE2-8920-5741011B347C@dilger.ca>
References: <FB78A152-53D3-4000-ABDB-9D6051ECB887@dilger.ca> <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <26505.1277899544@redhat.com> <30875.1277939713@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <30875.1277939713-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2010-06-30, at 17:15, David Howells wrote:
> Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:
>>> Passing -1 (or ULONGLONG_MAX) to get everything would be reasonable.
>> 
>> NOOOO.  That is exactly what we _don't_ want, since it makes it impossible
>> for the kernel to actually understand which fields the application is ready
>> to handle.  If the application always uses XSTAT_QUERY_ALL, instead of "-1",
>> then the kernel can easily tell which fields are present in the userspace
>> structure, and what it should avoid touching.
>> 
>> If applications start using "-1" to mean "all fields", then it will work so
>> long as the kernel and userspace agree on the size of struct xstat, but as
>> soon as the kernel understands some new field, but userspace does not, the
>> application will segfault or clobber random memory because the kernel thinks
>> it is asking for XSTAT_QUERY_NEXT_NEW_FIELD|... when it really isn't asking
>> for that at all.
> 
> As long as the field bits allocated in order and the extra results are tacked
> on in bit number order, will it actually be a problem?  Userspace must know how to deal with all the bits up to the last one it knows about; anything beyond that is irrelevant.

The patch you sent seems to get this right, but just for completeness, I'll answer in this thread.  Using the new struct as an example:

	#define XSTAT_REQUEST_GEN		0x00001000ULL
	#define XSTAT_REQUEST_DATA_VERSION	0x00002000ULL

        struct xstat {
                :
                :
		unsigned long long	st_data_version;
		unsigned long long	st_result_mask;
		unsigned long long	st_extra_results[0];
        }

An app "today" would allocate a struct xstat that ends at st_result_mask, and "today's" kernel will not know anything about flags beyond *_DATA_VERSION.  Even if today's app incorrectly uses request_mask = ~0ULL nothing will break until the kernel code changes.

If a future kernel gets a new static field at st_extra_results (say unsigned long long st_ino_high) with a new flag XSTAT_REQUEST_INO_HIGH 0x000040000ULL the kernel will think that the old app is requesting this field, and will fill in the 64-bit field at st_extra_results[1] (which the old app didn't allocate space for, nor does it understand) and may get a segfault, or stack smashing, or random heap corruption.

> What would you have me do?  Return an error if a request is made that the
> kernel doesn't support?  That's bad too.  This can be handled simply by
> clearing the result bit for any unsupported field.

I agree the desirable behaviour is if an app correctly sets request_mask at most to XSTAT_REQUEST__ALL_STATS 0x00003fffULL (or whatever it is at the time the app is compiled that matches the current struct xstat), and if the kernel understands e.g. XSTAT_REQUEST_INO_HIGH or not is irrelevant since the kernel will not touch fields that are not requested.  Likewise, if the application is compiled with a newer/larger XSTAT_REQUEST__ALL_STATS mask than what the kernel understands, the kernel will ignore the flags it doesn't understand.


Cheers, Andreas
