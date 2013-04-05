From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] xfstests: Check concurrently of readdir and read on the
 same directory fd
Date: Fri, 5 Apr 2013 12:28:29 -0500
Message-ID: <515F09BD.606@sgi.com>
References: <515BC786.3070102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <david@fromorbit.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <515BC786.3070102@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Zhao,

Thanks for submitting this test.

Only two minor errors that will be corrected at commit time.

1. The new script used generate this test produces errors.
   No need to resubmit, this has already been fixed by
   commit 8575764a "xfstests: fix common source file path"

      QA output created by 310
     +./tests/generic/310: line 43: ./common.rc: No such file or directory
     +./tests/generic/310: line 44: ./common.filter: No such file or 
directory
     +./tests/generic/310: line 47: _supported_fs: command not found
     +./tests/generic/310: line 48: _supported_os: command not found

2. Whitespace errors
   Warning: trailing whitespace in line 18 of src/t_readdir_2.c
   Warning: trailing whitespace in lines 18,28 of src/t_readdir_1.c

   space before tab in indent. tests/generic/310
                                 	perror("Seek failed!");
warning: 1 line adds whitespace errors.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>
