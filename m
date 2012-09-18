From: Jie Liu <jeff.liu@oracle.com>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Date: Tue, 18 Sep 2012 10:29:07 +0800
Message-ID: <5057DC73.4000101@oracle.com>
References: <nsxa9wojdcd.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <nsxa9wojdcd.fsf@closure.thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On 09/18/12 10:04, Theodore Ts'o wrote:
> Does anyone have test cases for SEEK_HOLE/SEEK_DATA handy?  As near as I
> can tell xfstests doesn't have any tests for SEEK_HOLE/SEEK_DATA
> functionality, and I was hoping someone had some test programs and test
> sets already written.
I have submitted two test cases to xfstests for this tests.

xfstests: introduce 285 for SEEK_DATA/SEEK_HOLE sanity test
xfstests: introduce 286 for SEEK_DATA/SEEK_HOLE copy test


Thanks,
-Jeff

